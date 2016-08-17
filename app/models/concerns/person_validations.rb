module PersonValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validates :sex, inclusion: RMS::SEX_CODES.keys, allow_nil: true
    validates :race, inclusion: RMS::RACE_CODES.keys, allow_nil: true
    validates :first_name, presence: true
    validates :last_name, presence: true
  end
end
