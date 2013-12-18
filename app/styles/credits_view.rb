Teacup::Stylesheet.new :credits_view do
  style :title_label,
    constraints: [
      :center_x,
      constrain(:top).equals(:superview, :top).plus(75)
    ]

  style :credits_name,
    textColor: :blue.uicolor,
    constraints: [
      :center_x,
      constrain(:top).equals(:superview, :top).plus(100)
    ]

  style :copyright_label,
    font: UIFont.systemFontOfSize(12),
    constraints: [
      constrain(:right).equals(:superview, :right).minus(20),
      constrain(:bottom).equals(:superview, :bottom).minus(20)
    ]
end
