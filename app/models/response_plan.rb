class ResponsePlan
  include ActiveModel::Model

  attr_accessor(
    :dob,
    :eyes,
    :hair,
    :height,
    :image,
    :license,
    :name,
    :race,
    :sex,
    :type,
    :weight,
  )
end
