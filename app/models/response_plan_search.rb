class ResponsePlanSearch
  include ActiveModel::Model
  validate :proper_date_format

  attr_accessor :name, :date_of_birth

  def close_matches
    response_plans = ResponsePlan

    if name.present?
      response_plans = response_plans.search(name)
    end

    if parsed_date_of_birth.present?
      response_plans = response_plans.where(date_of_birth: date_of_birth_range)
    end

    response_plans.all
  end

  private

  def proper_date_format
    if date_of_birth.present? && parsed_date_of_birth.nil?
      errors.add(:date_of_birth, "... not recognized as a valid date.")
    end
  end

  def date_of_birth_range
    (parsed_date_of_birth - 1.year)..(parsed_date_of_birth + 1.year)
  end

  def parsed_date_of_birth
    @parsed_date_of_birth ||= Chronic.parse(date_of_birth)
  end
end
