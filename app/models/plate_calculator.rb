class PlateCalculator
  BAR_WEIGHT = 45
  PLATE_WEIGHTS = [45, 35, 25, 10, 5, 2.5, 1.25]

  attr_accessor :plate_counts
  def initialize(bar_weight=nil, plate_counts=nil)
    @bar_weight = bar_weight || BAR_WEIGHT
    @plate_counts = plate_counts || Hash[PLATE_WEIGHTS.map{|w| [w, 10]}]
  end

  def plates(weight)
    weight = (weight.to_f - @bar_weight) / 2.0
    results = []

    PLATE_WEIGHTS.each do |plate_weight|
      @plate_counts[plate_weight].times do
        if weight >= plate_weight
          results << plate_weight
          weight -= plate_weight
        end
        break if weight == 0
      end
    end
    results
  end

  def set_plate_count(plate_weight, count)
    @plate_counts = @plate_counts.merge(plate_weight => count)
  end

  def set_bar_weight(bar_weight)
    @bar_weight = bar_weight
  end
end
