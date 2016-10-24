require "oci8"
require "csv"
require "rms_person_parser"
require "rms_incident_parser"
require "action_view/helpers/text_helper"

class RMSImporter
  include ActionView::Helpers::TextHelper

  SQL_QUERY = <<-SQL.freeze
    select crisis.*,person.*,particulars.*
    from intspd.xml_crisis crisis
    inner join vrcspd.event_person on crisis.event_rin = event_person.rin
    inner join vrcspd.person_name person on person.pin = event_person.pin
    inner join vrcspd.per_particulars particulars on particulars.pin = person.pin
    where instr(crisis.crisis_contacted_first_name, trim(person.g1)) > 0
    and instr(crisis.crisis_contacted_last_name, trim(person.surname)) > 0
  SQL

  XML_CRISIS_IDS_QUERY = <<-SQL.freeze
    select xml_crisis_id from intspd.xml_crisis
  SQL

  def import
    create_log_path

    results = query(SQL_QUERY)
    results.each { |result| parse_sql_result(result) }

    update_visibility

    log_unimported_incidents
    log_duplicate_incidents(results)
  end

  def duplicated_log_file
    log_path.join("duplicated.csv")
  end

  def unimported_log_file
    log_path.join("unimported.log")
  end

  def unprocessable_log_file
    log_path.join("unprocessable.log")
  end

  private

  def create_log_path
    FileUtils.mkdir_p(log_path)
    FileUtils.touch(unprocessable_log_file)
  end

  def log_path
    @log_path ||= Rails.root.join(
      "log",
      "import",
      "#{Rails.env}.#{Time.now.iso8601}",
    )
  end

  def parse_sql_result(result)
    person_parser = RMSPersonParser.new(result)
    incident_parser = RMSIncidentParser.new(result)

    rms_person = RMS::Person.find_or_initialize_by(pin: result.fetch("PIN"))
    rms_person.person ||= Person.new.tap { |p| p.save!(validate: false) }
    rms_person.update!(person_parser.parsed_attributes)

    incident = RMS::CrisisIncident.find_or_initialize_by(
      xml_crisis_id: incident_parser.xml_crisis_id,
    )

    incident_attributes = incident_parser.
      parsed_attributes.
      merge(rms_person: rms_person)

    incident.update! incident_attributes
  rescue => error
    log_unprocessable_entry(error, result)
  end

  def log_unimported_incidents
    File.write(unimported_log_file, unimported_ids.join("\n"))
  end

  def log_duplicate_incidents(incidents)
    incidents_by_id = incidents.group_by { |i| i.fetch("XML_CRISIS_ID") }
    duplicate_incidents = incidents_by_id.
      select { |id, incident| incident.count > 1 }.
      map { |id, incident| incident }.
      flatten

    write_csv(duplicated_log_file, duplicate_incidents)
  end

  def log_unprocessable_entry(error, result)
    open(unprocessable_log_file, 'a') do |f|
      f.puts "------------------------------------------------------"
      f.puts error.to_s
      f.puts
      f.puts error.backtrace.join("\n")
      f.puts
      f.puts result.inspect
      f.puts
    end
  end

  def unimported_ids
    imported_ids = RMS::CrisisIncident.pluck(:xml_crisis_id)
    all_ids = query(XML_CRISIS_IDS_QUERY).map { |r| r.fetch("XML_CRISIS_ID") }

    all_ids.uniq.map(&:to_i) - imported_ids.uniq
  end

  def write_csv(filepath, data)
    CSV.open(filepath, "w") do |csv|
      if data.any?
        csv << data.first.keys

        data.each do |row|
          csv << row.values
        end
      end
    end
  end

  def query(string)
    results = []
    cursor = connection.exec(string)

    while row = cursor.fetch_hash
      results << row
    end

    results
  end

  def update_visibility
    new_visibilities = []

    new_people_over_threshold.each do |person_id|
      new_visibilities << Visibility.create!(
        person_id: person_id,
        creation_notes: crossed_threshold_message,
      )
    end

    alert_for_new_visibilities(new_visibilities)
  end

  def new_people_over_threshold
    people_over_threshold - people_with_current_or_former_visibility
  end

  def people_with_current_or_former_visibility
    Visibility.pluck(:person_id).uniq
  end

  def people_over_threshold
    RMS::Person.
      where(id: rms_people_over_threshold).
      pluck(:person_id)
  end

  def rms_people_over_threshold
    RMS::CrisisIncident.
      where(reported_at: (Person::RECENT_TIMEFRAME.ago..Time.current)).
      group(:rms_person_id).
      count.
      reject { |_, incident_count| incident_count < threshold }.
      keys
  end

  def crossed_threshold_message
    threshold_text = pluralize(threshold, "RMS Crisis Incident")
    "[AUTO] Person crossed the threshold of #{threshold_text}"
  end

  def threshold
    ENV.fetch("RECENT_CRISIS_INCIDENT_THRESHOLD").to_i
  end

  def alert_for_new_visibilities(visibilities)
    visibilities.each do |visibility|
      message = VisibilityMailer.crossed_threshold(visibility)
      EmailService.send(message)
    end
  end

  def connection
    @connection ||= OCI8.new(
      ENV.fetch("RMS_USERNAME"),
      ENV.fetch("RMS_PASSWORD"),
      ENV.fetch("RMS_URL"),
    )
  end
end
