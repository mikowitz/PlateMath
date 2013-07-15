class PlateViewScreen < PM::Screen
  include HasContainer
  stylesheet :plate_view
  layout :plate_view do
    @buttons = subview(UIView, :buttons) do
      @left_button = subview(UIButton, :left_button)
      @right_button = subview(UIButton, :right_button)
      @weight_text_field = subview(UITextField, :weight_text_field)
    end
    @bar_view = subview(UIView, :bar_view) do
      subview(UIView, :thin_bar)
      subview(UIView, :left_bar)
      subview(UIView, :right_bar)
      subview(UIView, :left_stopper)
      subview(UIView, :right_stopper)
    end
  end

  def will_appear
    add_gestures
  end

  def add_gestures
    self.view.on_swipe(:right) do |swipe|
      swipe(:right, -OFFSET)
    end
    self.view.on_swipe(:left) do |swipe|
      swipe(:left, OFFSET)
    end
  end

  def swipe(direction, expected_offset)
    other_direction = direction == :left ? :right : :left
    if self.view.origin.x == 0
      container.show_menu(other_direction)
    elsif self.view.origin.x == expected_offset
      container.hide_menu(direction)
    end
  end
end
