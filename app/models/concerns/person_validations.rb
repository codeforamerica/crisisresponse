module PersonValidations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validates :first_name, presence: true
    validates :last_name, presence: true

    validates :sex, inclusion: RMS::SEX_CODES.keys, allow_blank: true
    validates :race, inclusion: RMS::RACE_CODES.keys, allow_blank: true

    validates(
      :hair_color,
      inclusion: RMS::HAIR_COLOR_CODES.values,
      allow_blank: true,
    )

    validates(
      :eye_color,
      inclusion: RMS::EYE_COLOR_CODES.values,
      allow_blank: true,
    )

    validates :middle_initial, format: {
      allow_blank: true,
      message: "must be a single letter",
      with: /\A.\z/,
    }
  end
end
