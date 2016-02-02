class Person
  include ActiveModel::Model

  attr_accessor :first_name, :last_name

  def name=(value)
    (@first_name, @last_name) = value.split
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

  def first_name
    @first_name.humanize
  end

  def last_name
    @last_name.humanize
  end
end
