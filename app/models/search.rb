class Search
  include ActiveModel::Model
  validate :proper_date_format

  SEARCHABLE_ATTRS = [
    :age,
    :date_of_birth,
    :eye_color,
    :hair_color,
    :height,
    :name,
    :weight,
    :sex,
    :race,
  ]

  attr_accessor(*SEARCHABLE_ATTRS)

  def initialize(*args)
    super(*args)

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

  def exact_matches
    []
  end

  def close_matches
    people = Person

    if name.present?
      people = people.search(name)
    end

    if date_of_birth.present?
      date_of_birth_range = range(date_of_birth, 1.year)
      people = people.where(date_of_birth: date_of_birth_range)
    end

    if age.present?
      expected_dob = (Date.today - age.to_i.years)
      expected_dob_range = range(expected_dob, 5.years)
      people = people.where(date_of_birth: expected_dob_range)
    end

    if height.present?
      height_range = range(height.to_i, 3)
      people = people.where(height_in_inches: height_range)
    end

    if weight.present?
      weight_range = range(weight.to_i, 25)
      people = people.where(weight_in_pounds: weight_range)
    end

    if eye_color.any?
      people = people.where(eye_color: eye_color)
    end

    if hair_color.any?
      people = people.where(hair_color: hair_color)
    end

    if race.any?
      people = people.where(race: race)
    end

    if sex.any?
      people = people.where(sex: sex)
    end

    people.all
  end

  def partial_matches
    []
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
end
