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
    add_gestures
  end

  def add_gestures
    self.view.on_swipe(:right) do |swipe|
      if self.view.origin.x == 0 && container.left_menu.present?
        container.show_menu(:left)
      elsif self.view.origin.x == -OFFSET
        container.hide_menu(:right)
      end
    end
    self.view.on_swipe(:left) do |swipe|
      if self.view.origin.x == 0 && container.right_menu.present?
        container.show_menu(:right)
      elsif self.view.origin.x == OFFSET
        container.hide_menu(:left)
      end
    end
  end
end
