class Officer < ActiveRecord::Base
  devise(
    :database_authenticatable,
    :recoverable,
    :timeoutable,
    :validatable,
  )

  has_many :authored_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :author_id,
    dependent: :destroy

  has_many :approved_response_plans,
    class_name: "ResponsePlan",
    foreign_key: :approver_id,
    dependent: :destroy

  def send_devise_notification(notification, *args)
    Email.send(devise_mailer.send(notification, self, *args))
  end
end
