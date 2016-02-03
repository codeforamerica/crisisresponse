class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :action_plan_steps,
    :city_state_zip,
    :dob,
    :eyes,
    :hair,
    :height,
    :image,
    :license_number,
    :license_state,
    :name,
    :needs,
    :past_encounters,
    :preparer,
    :race,
    :sex,
    :street_address,
    :timestamp,
    :type,
    :veteran,
    :weight,
  )
end
