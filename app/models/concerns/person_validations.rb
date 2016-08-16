module PersonValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validates :sex, inclusion: Person::SEX_CODES.keys, allow_nil: true
    validates :race, inclusion: Person::RACE_CODES.keys, allow_nil: true
    validates :date_of_birth, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
  end
end
