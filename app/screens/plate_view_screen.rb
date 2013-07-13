class PlateViewScreen < PM::Screen
  include HasContainer
  stylesheet :plate_math
  layout :plate_view do
    @label = subview(UILabel, :label)
  end

  def will_appear
    self.view.backgroundColor = :blue.uicolor
    @label.text = "PlateViewScreen"
    @label.sizeToFit
  end
end
