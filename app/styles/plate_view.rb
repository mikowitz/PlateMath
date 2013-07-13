Teacup::Stylesheet.new :plate_view do
  @clear = :clear.uicolor
  @backgroundGray = 0xf0f0f0.uicolor
  @barGray = :gray.uicolor

  style :plate_view,
    backgroundColor: @backgroundGray

  style :bar_view,
    backgroundColor: @clear,
    constraints: [
      :full_width,
      :left,
      constrain_top(85),
      constrain_height(100)
    ]

  style :thin_bar,
    backgroundColor: @barGray,
    constraints: [
      :center_x,
      :center_y,
      constrain(:width).equals(:superview, :width).minus(20),
      constrain_height(8)
    ]

  style :left_bar,
    backgroundColor: @barGray,
    constraints: [
      :center_y,
      constrain_height(16),
      constrain_width(100),
      constrain(:left).equals(:superview, :left).plus(10)
    ]

  style :right_bar,
    backgroundColor: @barGray,
    constraints: [
      :center_y,
      constrain_height(16),
      constrain_width(100),
      constrain(:right).equals(:superview, :right).minus(10)
    ]

  style :left_stopper,
    backgroundColor: @barGray,
    constraints: [
      :center_y,
      constrain_height(24),
      constrain_width(16),
      constrain(:left).equals(:superview, :left).plus(110)
    ]

  style :right_stopper,
    backgroundColor: @barGray,
    constraints: [
      :center_y,
      constrain_height(24),
      constrain_width(16),
      constrain(:right).equals(:superview, :right).minus(110)
    ]
end
