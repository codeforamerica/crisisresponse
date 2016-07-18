require "csv"

class CsvImporter
  def initialize(data_dir)
    @data_dir = data_dir
  end

  attr_reader :data_dir

  def csv_path
    Rails.root.join(data_dir, "response_plans.csv")
  end

  def image_dir
    Rails.root.join(data_dir, "images")
  end

  def create_records
    data.map do |csv_row|
      person_attrs = parse_person(csv_row)
      response_plan_attrs = parse_response_plan(csv_row)
      response_strategy_attrs = filter(parse_response_strategies(csv_row))
      contact_attrs = filter(parse_contacts(csv_row))
      image_attrs = parse_images(csv_row)
      identifying_attrs = person_attrs.slice(:first_name, :last_name)

      person = Person.find_or_initialize_by(identifying_attrs)
      response_plan = ResponsePlan.find_or_initialize_by(person: person)

      person.update_attributes(person_attrs)
      response_plan.update_attributes(response_plan_attrs)

      response_plan.author = Officer.find_or_create_by!(parse_author_attrs(csv_row))
      response_plan.approver = Officer.find_or_create_by!(parse_approver_attrs(csv_row))

      response_plan.save!

      response_plan.response_strategies = response_strategy_attrs.map {|attrs| ResponseStrategy.create!(attrs.merge(response_plan: response_plan)) }
      response_plan.contacts = contact_attrs.map {|attrs| Contact.create!(attrs.merge(response_plan: response_plan)) }
      response_plan.images = image_attrs.map { |attrs| Image.create!(attrs.merge(response_plan: response_plan)) }

      response_plan
    end
  end

  def data
    data = File.read(csv_path).gsub(" ", " ")
    CSV.parse(data, headers: true)
  end

  def parse_person(csv_row)
    {
      first_name: csv_row["First Name"],
      last_name: csv_row["Last Name"],
      date_of_birth: Date.strptime(csv_row["DOB"], "%m-%d-%Y"),
      race: parse_race(csv_row["Race"]),
      sex: csv_row["Gender"].titlecase,
      height_in_inches: parse_height(csv_row["Height"]),
      weight_in_pounds: csv_row["Weight"],
      hair_color: csv_row["Hair"],
      eye_color: csv_row["Eye"],
      scars_and_marks: csv_row["Scars, Marks, and Tatoos"],
      location_name: csv_row["Current residence (title)"],
      location_address: parse_address(csv_row),
    }
  end

  def parse_response_plan(csv_row)
    {
      alias_list: csv_row["Aliases"].to_s.split(",").map(&:strip),
      background_info: csv_row["Background Info"],
    }
  end

  def parse_address(csv_row)
    %w[street city state zip].map do |address_component|
      csv_row["Current residence (#{address_component})"]
    end.compact.join(", ")
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

  def parse_images(csv_row)
    name = [
      csv_row["Last Name"].downcase,
      csv_row["First Name"].downcase,
    ].join("_")

    image_path = "#{image_dir}/#{name}/*".gsub(" ", "_")
    images = Dir.glob(image_path)

    images.map do |image|
      { source: File.open(image) }
    end
  end

  def parse_response_strategies(csv_row)
    strategies = [
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
    ]

    strategies.reject do |strategy|
      strategy[:title].to_s.blank? &&
        strategy[:description].to_s.blank?
    end
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

  def filter(array_of_hashes)
    array_of_hashes.select { |hash| hash.values.compact.any?(&:present?)  }
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
