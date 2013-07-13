class AvailablePlatesFormScreen < PM::Screen
  stylesheet :plate_math
  layout :settings do
    @label = subview(UILabel, :label)
  end

  def will_appear
    self.view.backgroundColor = :maroon.uicolor
    @label.text = "AvailablePlates"
    @label.sizeToFit
  end
end
