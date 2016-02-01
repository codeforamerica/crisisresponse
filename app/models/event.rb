class Event
  def initialize(data)
    @data = data
  end

  def method_missing(method)
    @data.fetch(method)
  end

  def go_id
    @data[:go_id].strip
  end

  def to_s
    "Event #{go_id.strip}"
  end

  def inspect
    "<#{to_s} #{reported_on_date} #{reported_on_time}>"
  end

  def name
    "#{crisis_contacted_first_name} #{crisis_contacted_first_name}"
  end

  def to_partial_path
    "events/event"
  end
end
