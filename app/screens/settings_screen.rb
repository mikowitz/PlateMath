class SettingsScreen < PM::Screen
  stylesheet :plate_math
  layout :settings do
    @label = subview(UILabel, :label)
  end

  def will_appear
    self.view.backgroundColor = :gray.uicolor
    @label.text = "Settings"
    @label.sizeToFit
  end
end
