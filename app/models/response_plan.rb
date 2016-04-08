class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :city_state_zip,
    :contacts,
    :image,
    :license_number,
    :license_state,
    :needs,
    :past_encounters,
    :preparer,
    :safety_notes,
    :street_address,
    :timestamp,
    :veteran,
  )
end
