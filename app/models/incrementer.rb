class Incrementer
  attr_reader :increment
  def initialize
    @increment = 2.5
    @count = 0
  end

  def tick!(weight)
    @count += 1
    if @count >= 5 && @count < 10 && weight % 5 == 0
      @increment = 5
    elsif @count >= 10 && weight % 10 == 0
      @increment = 10
    end
  end

  def reset!
    @count = 0
    @increment = 2.5
  end
end
