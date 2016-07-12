class Search
  include ActiveModel::Model
  validate :proper_date_format

  ACCEPTED_DATE_FORMATS = [
    "%m/%d/%Y",
    "%m/%d/%y",
    "%m-%d-%Y",
    "%m-%d-%y",
    "%m%d%Y",
    "%m%d%y",
    "%Y-%m-%d",
  ].freeze

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
    parse_date_of_birth
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
    response_plans = ResponsePlan

    if name.present?
      response_plans = response_plans.search(name)
    end

    if date_of_birth.present?
      date_of_birth_range = range(date_of_birth, 1.year)
      response_plans = response_plans.where(date_of_birth: date_of_birth_range)
    end

    if age.present?
      expected_dob = (Date.today - age.to_i.years)
      expected_dob_range = range(expected_dob, 5.years)
      response_plans = response_plans.where(date_of_birth: expected_dob_range)
    end

    if height.present?
      height_range = range(height.to_i, 3)
      response_plans = response_plans.where(height_in_inches: height_range)
    end

    if weight.present?
      weight_range = range(weight.to_i, 25)
      response_plans = response_plans.where(weight_in_pounds: weight_range)
    end

    if eye_color.any?
      response_plans = response_plans.where(eye_color: eye_color)
    end

    if hair_color.any?
      response_plans = response_plans.where(hair_color: hair_color)
    end

    if race.any?
      response_plans = response_plans.where(race: race)
    end

    if sex.any?
      response_plans = response_plans.where(sex: sex)
    end

    response_plans.all
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
      errors.add(:date_of_birth, "Ignored invalid date. Try 'MM/DD/YY'")
    end
  end

  # TODO extract this out into a Date of Birth class to handle parsing
  def parse_date_of_birth
    if @date_of_birth.present?
      @date_of_birth = ACCEPTED_DATE_FORMATS.map do |format|
        attempted_parse = Date.strptime(@date_of_birth, format) rescue nil
        feasible = (120.years.ago.to_date..Date.today).cover?(attempted_parse)
        feasible ? attempted_parse : nil
      end.compact.first

      if @date_of_birth.nil?
        @invalid_date = true
      end
    end
  end
end
