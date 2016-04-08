class Person < ActiveRecord::Base
  has_many :response_strategies

  def name=(value)
    (self.first_name, self.last_name) = value.split
  end

  def name
    "#{first_name} #{last_name}"
  end

  def events_from(events)
    events.select! do |event|
      event.crisis_contacted_first_name.downcase == first_name.downcase &&
        event.crisis_contacted_last_name.downcase == last_name.downcase
    end
  end

  def to_param
    name
  end
end
