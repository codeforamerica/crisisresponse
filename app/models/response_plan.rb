class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :action_plan_steps,
    :dob,
    :eyes,
    :hair,
    :height,
    :image,
    :license,
    :name,
    :past_encounters,
    :preparer,
    :race,
    :sex,
    :timestamp,
    :type,
    :veteran,
    :weight,
  )
end
