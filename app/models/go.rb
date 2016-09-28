class GO
  def initialize(number)
    @number = number
  end

  def display
    "GO # #{number[0...4]}-#{number[4..-1]}"
  end

  private

  attr_reader :number
end
