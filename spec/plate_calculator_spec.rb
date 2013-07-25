describe PlateCalculator do
  before do
    @calculator = PlateCalculator.new
  end

  it 'should calculate correctly with unlimited plates' do
    @calculator.plates(45).should == []
    @calculator.plates(50).should == [2.5]
    @calculator.plates(85).should == [10, 10]
    @calculator.plates(100).should == [25, 2.5]
    @calculator.plates(102.5).should == [25, 2.5, 1.25]
  end

  it 'should calculate corectly with limited plates' do
    @calculator.set_plate_count(10, 1)
    @calculator.plates(85).should == [10, 5, 5]

    @calculator.set_plate_count(35, 0)
    @calculator.plates(115).should == [25, 10]
  end

  it 'should calculate correctly with a different bar weight' do
    @calculator.set_bar_weight(25)
    @calculator.plates(85).should == [25, 5]
  end
end
