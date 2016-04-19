class Person < ActiveRecord::Base
  has_many :response_strategies

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def name
    "#{first_name} #{last_name}"
  end

  def to_param
    name
  end
end
