# This class is responsible for searching the people in our app,
# based on their name date of birth, and physical characteristics.
#
# Because many of the people in our app are pulled
# from the records management system (RMS),
# we have people stored in both the `Person` and `RMS::Person` models.
# This class must search through both tables
# in order to return all matching results.
#
# To do this,
# the search starts with the `Person` model,
# and looks for matching attributes on the record.
# If an attribute is not defined on `Person`,
# and the `Person` has an associated `RMS::Person`,
# then we fall back to searching the attributes on the `RMS::Person`.
class Search
  include ActiveModel::Model
  validate :proper_date_format

  SEARCHABLE_ATTRS = [
    :age,
    :date_of_birth,
    :eye_color,
    :hair_color,
    :height_feet,
    :height_inches,
    :name,
    :weight_in_pounds,
    :sex,
    :race,
  ]

  attr_accessor(*SEARCHABLE_ATTRS)

  def initialize(attributes = {}, candidates = Person.all)
    super(attributes)

    @candidates = candidates

    if @date_of_birth.present?
      parse_date_of_birth
    end
  end

  def active?
    active_filters.any?
  end

  def active_filters
    SEARCHABLE_ATTRS.select do |attr|
      public_send(attr).present?
    end
  end

  def attributes
    SEARCHABLE_ATTRS.map { |attr| [attr, public_send(attr)] }.to_h
  end

  def close_matches
    people = @candidates.
      joins("LEFT OUTER JOIN rms_people ON rms_people.person_id = people.id")

    if name.present?
      people = people.search(name)
    end

    if date_of_birth.present?
      date_of_birth_range = range(date_of_birth, 1.year)
      people = query_value_based_on_range(people, :date_of_birth, date_of_birth_range)
    end

    if age.present?
      expected_dob = (Date.today - age.to_i.years)
      expected_dob_range = range(expected_dob, 5.years)
      people = query_value_based_on_range(people, :date_of_birth, expected_dob_range)
    end

    if height_inches.present? || height_feet.present?
      height_in_inches = height_feet.to_i * 12 + height_inches.to_i
      height_range = range(height_in_inches.to_i, 3)
      people = query_value_based_on_range(people, :height_in_inches, height_range)
    end

    if weight_in_pounds.present?
      weight_range = range(weight_in_pounds.to_i, 25)
      people = query_value_based_on_range(people, :weight_in_pounds, weight_range)
    end

    if eye_color.any?
      people = query_for_array_of_values(people, :eye_color, eye_color)
    end

    if hair_color.any?
      people = query_for_array_of_values(people, :hair_color, hair_color)
    end

    if race.any?
      people = query_for_array_of_values(people, :race, race)
    end

    if sex.any?
      people = query_for_array_of_values(people, :sex, sex)
    end

    people.order(<<-SQL)
      CASE WHEN people.last_name IS NOT NULL
      THEN people.last_name
      ELSE rms_people.last_name
      END
    SQL
  end

  def eye_color
    Array(@eye_color).map(&:presence).compact
  end

  def hair_color
    Array(@hair_color).map(&:presence).compact
  end

  def race
    Array(@race).map(&:presence).compact
  end

  def sex
    Array(@sex).map(&:presence).compact
  end

  private

  def range(value, error_bars)
    (value - error_bars) .. (value + error_bars)
  end

  def proper_date_format
    if @invalid_date
      errors.add(:date_of_birth, "Ignored invalid date. Try 'mm-dd-yyyy'")
    end
  end

  def parse_date_of_birth
    @date_of_birth = Date.strptime(@date_of_birth, "%m-%d-%Y")
  rescue ArgumentError
    @invalid_date = true
    @date_of_birth = nil
  end

  # Query both `Person` and associated `RMS::Person` models
  # for an attribute that falls within a given range of values.
  #
  # e.g. `date_of_birth BETWEEN 1969 AND 1970`
  def query_value_based_on_range(relation, attribute, range)
    relation.where(<<-SQL)
      people.#{attribute} BETWEEN '#{range.min}' AND '#{range.max}'
      OR (
        people.#{attribute} is null
        AND rms_people.#{attribute} BETWEEN '#{range.min}' AND '#{range.max}'
      )
    SQL
  end

  # Query both `Person` and associated `RMS::Person` models
  # for an attribute that is included in a list of values.
  #
  # e.g. `hair_color IN ('black','brown')`
  def query_for_array_of_values(relation, attribute, values)
    selected_values = "(#{values.map {|s| "'#{s}'"}.join(",")})"

    relation.where(<<-SQL)
      people.#{attribute} IN #{selected_values}
      OR (
        people.#{attribute} is null
        AND rms_people.#{attribute} IN #{selected_values}
      )
    SQL
  end
end
