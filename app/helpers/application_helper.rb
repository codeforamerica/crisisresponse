module ApplicationHelper
  def tel_to(text, options = {})
    groups = text.to_s.scan(/(?:^\+)?\d+/)

    if block_given?
      link_to("tel:#{groups.join '-'}", options) { yield }
    else
      link_to text, "tel:#{groups.join '-'}", options
    end
  end
end
