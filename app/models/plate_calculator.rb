class PlateCalculator
  BAR_WEIGHT = 45
  PLATE_WEIGHTS = %w( 45 35 25 10 5 2.5 1.25 )

  attr_accessor :plate_counts
  def initialize(bar_weight=nil, plate_counts=nil)
    @bar_weight = bar_weight || BAR_WEIGHT
    @plate_counts = Hash[PLATE_WEIGHTS.map{|w| [w, 10]}]
    if plate_counts != nil
      set_plate_counts(plate_counts) 
    end
  end

  def plates(weight)
    weight = (weight.to_f - @bar_weight) / 2.0
    results = []

    PLATE_WEIGHTS.each do |plate_weight|
      to_f_or_i(@plate_counts[plate_weight]).times do
        if weight >= plate_weight.to_f
          results << to_f_or_i(plate_weight)
          weight -= plate_weight.to_f
        end
        break if weight == 0
      end
    end
    results
  end

  def to_f_or_i(string)
    ((float = Float(string)) && (float % 1.0 == 0) ? float.to_i : float)
  end

  def set_plate_count(plate_weight, count)
    count = 10 if count == ""
    @plate_counts = @plate_counts.merge(plate_weight => count)
  end

  def set_plate_counts(plate_counts={})
    plate_counts.each do |weight, count|
      set_plate_count(weight, count)
    end
  end

  def set_bar_weight(bar_weight)
    @bar_weight = bar_weight
  end
end
