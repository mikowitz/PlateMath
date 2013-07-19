class HorizontalGradientLayer
  def self.layer(direction)
    layer = CAGradientLayer.layer
    start_point, end_point = direction == :right ? [0.0, 0.75] : [1.0, 0.25]
    layer.setStartPoint CGPointMake(start_point, 0.5)
    layer.setEndPoint   CGPointMake(end_point, 0.5)
    layer.colors = [0xe8e8e8.uicolor.CGColor, 0xd8d8d8.uicolor.CGColor]
    layer
  end
end
