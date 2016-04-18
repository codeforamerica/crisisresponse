class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :city_state_zip,
    :image,
    :license_number,
    :license_state,
    :preparer,
    :timestamp,
  )
end
