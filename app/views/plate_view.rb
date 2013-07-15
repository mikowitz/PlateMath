class PlateView < UIView
  COLOR = 0x333333.uicolor
  PLATE_DIMENSIONS = {
    45 => [136, 12],
    35 => [110, 12],
    25 => [88, 11],
    10 => [68, 10],
    5 => [60, 6],
    2.5 => [50, 5],
    1.25 => [42, 4]
  }

  def initWithWeight(weight, atX: x)
    height, width = PLATE_DIMENSIONS[weight]
    frame = SugarCube::CoreGraphics.Rect(x, 50 - (height / 2), width, height)
    initWithFrame(frame) 
    self.backgroundColor = COLOR
    self
  end
end
