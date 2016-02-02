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
    :race,
    :sex,
    :type,
    :veteran,
    :weight,
  )
end
