class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :city_state_zip,
    :contacts,
    :image,
    :license_number,
    :license_state,
    :preparer,
    :safety_notes,
    :timestamp,
  )
end
