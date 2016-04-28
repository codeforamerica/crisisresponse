require "csv"

class CsvImporter
  def initialize(csv_path)
    @csv_path = csv_path
  end

  attr_reader :csv_path

  def create_records
    data.map do |csv_row|
      response_plan_attributes = parse_response_plan(csv_row)
      response_strategy_attrs = filter(parse_response_strategies(csv_row))
      contact_attrs = filter(parse_contacts(csv_row))
      safety_warning_attrs = filter(parse_safety_warnings(csv_row))

      response_plan = ResponsePlan.new(response_plan_attributes)
      response_plan.author = Officer.find_or_create_by!(parse_author_attrs(csv_row))
      response_plan.approver = Officer.find_or_create_by!(parse_approver_attrs(csv_row))
      response_plan.save!

      response_plan.response_strategies = response_strategy_attrs.map {|attrs| ResponseStrategy.create!(attrs.merge(response_plan: response_plan)) }
      response_plan.contacts = contact_attrs.map {|attrs| Contact.create!(attrs.merge(response_plan: response_plan)) }
      response_plan.safety_warnings = safety_warning_attrs.map {|attrs| SafetyWarning.create!(attrs.merge(response_plan: response_plan)) }

      response_plan
    end
  end

  def data
    CSV.parse(File.read(csv_path), headers: true)
  end

  def parse_response_plan(csv_row)
    {
      first_name: csv_row["First Name"],
      last_name: csv_row["Last Name"],
      date_of_birth: Chronic.parse(csv_row["DOB"]),
      race: parse_race(csv_row["Race"]),
      sex: csv_row["Gender"].titlecase,
      height_in_inches: parse_height(csv_row["Height"]),
      weight_in_pounds: csv_row["Weight"],
      hair_color: csv_row["Hair"],
      eye_color: csv_row["Eye"],
      scars_and_marks: csv_row["Scars, Marks, and Tatoos"],
      image: parse_image(csv_row),
    }
  end

  def parse_race(race)
    {
      white: "WHITE",
      black: "AFRICAN AMERICAN/BLACK",
      asian: "ASIAN (ALL)/PACIFIC ISLANDER",
    }.with_indifferent_access[race.try(:downcase)] || "UNKNOWN"
  end

  def parse_height(height)
    feet, inches = height.split("'")
    Integer(feet) * 12 + inches.to_i
  rescue
    nil
  end

  def parse_image(csv_row)
    image_dir = Rails.root + "#{File.dirname(csv_path)}/images"
    image_path = "#{image_dir}/#{csv_row["Last Name"].downcase}_#{csv_row["First Name"].downcase}/*"
    images = Dir.glob(image_path)

    if images.any?
      File.open(images.first)
    end
  end

  def parse_response_strategies(csv_row)
    [
      {
        priority: 1,
        title: csv_row["Step 1: Title"],
        description: csv_row["Step 1: Details"],
      },
      {
        priority: 2,
        title: csv_row["Step 2: Title"],
        description: csv_row["Step 2: Details"],
      },
      {
        priority: 3,
        title: csv_row["Step 3: Title"],
        description: csv_row["Step 3: Details"],
      },
      {
        priority: 4,
        title: csv_row["Step 4: Title"],
        description: csv_row["Step 4: Details"],
      },
      {
        priority: 5,
        title: csv_row["Step 5: Title"],
        description: csv_row["Step 5: Details"],
      },
    ].reject { |strategy| strategy[:title].nil? && strategy[:description].nil?  }
  end

  def parse_contacts(csv_row)
    [
      {
        name: csv_row["Name - 1"],
        relationship: csv_row["Relationship - 1"],
        cell: csv_row["Phone Number - 1"],
        notes: csv_row["Notes - 1"],
      },
      {
        name: csv_row["Name - 2"],
        relationship: csv_row["Relationship - 2"],
        cell: csv_row["Phone Number - 2"],
        notes: csv_row["Notes - 2"],
      },
      {
        name: csv_row["Name - 3"],
        relationship: csv_row["Relationship - 3"],
        cell: csv_row["Phone Number - 3"],
        notes: csv_row["Notes - 3"],
      },
    ]
  end

  def parse_safety_warnings(csv_row)
    [
      csv_row["Gun (notes)"],
      csv_row["Knife (notes)"],
      csv_row["Other Weapon (notes)"],
      csv_row["Needles (notes)"],
      csv_row["General Violence (notes)"],
      csv_row["Assault on police (notes)"],
      csv_row["Spitting (notes)"],
      csv_row["Suidice by cop (notes)"],
    ].compact.map { |w| { description: w } }
  end

  def filter(array_of_hashes)
    array_of_hashes.select { |hash| hash.values.compact.any?  }
  end

  def parse_author_attrs(csv_row)
    {
      name: csv_row["Officer name"],
      unit: csv_row["Unit"],
      phone: csv_row["Phone #"],
    }
  end

  def parse_approver_attrs(csv_row)
    {
      name: csv_row["Approving Sgt"],
      unit: csv_row["Unit"],
    }
  end
end
