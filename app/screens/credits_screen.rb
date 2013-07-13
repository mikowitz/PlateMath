class CreditsScreen < PM::Screen
  stylesheet :plate_math
  layout :settings do
    @label = subview(UILabel, :label)
  end

  def will_appear
    self.view.backgroundColor = :green.uicolor
    @label.text = "Credits"
    @label.sizeToFit
  end
end
