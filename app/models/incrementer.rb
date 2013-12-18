class Incrementer
  attr_reader :increment
  def self.with_minimum_increment(data)
    min_plate = data.select{|k, v| v != "0"}.keys.map(&:to_f).sort.first
    self.new(min_plate * 2)
  end

  def initialize(increment=2.5)
    @original_increment = @increment = increment
    @count = 0
  end

  def tick!(weight)
    @count += 1
    if @count >= 5 && @count < 10 && weight % 5 == 0
      @increment = @original_increment * 2
    elsif @count >= 10 && weight % 10 == 0
      @increment = @original_increment * 4
    end
  end

  def reset!
    @count = 0
    @increment = @original_increment
  end
end
