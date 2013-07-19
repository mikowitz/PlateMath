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
    add_button_controls
    add_notifications
    @weight_text_field.text = App::Persistence['weight'].to_s
    @weight_text_field.delegate = self
    @incrementer = Incrementer.new

    self.view.on_tap { weight_did_finish_editing }
  end

  def add_gestures
    self.view.on_swipe(:right) do |swipe|
      swipe(:right, -OFFSET)
    end
    self.view.on_swipe(:left) do |swipe|
      swipe(:left, OFFSET)
    end
  end

  def increase_weight
    add_gradient :right
    change_weight :+
    @timer = 300.milliseconds.every { change_weight :+ }
  end

  def decrease_weight
    add_gradient :left
    change_weight :-
    @timer = 300.milliseconds.every { change_weight :- }
  end
  
  def change_weight(operator)
    old_weight = @weight_text_field.text.to_f
    new_weight = old_weight.send(operator, @incrementer.increment)
    @weight_text_field.text = new_weight.to_s
    @incrementer.tick!(new_weight)
  end

  def add_button_controls
    setup_button(@right_button, '+') { increase_weight }
    setup_button(@left_button, '-') { decrease_weight }
  end

  def setup_button(button, title, &on_touch)
    button.setTitle(title, forState: :normal.uicontrolstate)
    button.on(:touch_start, &on_touch)
    button.on(:touch_stop) { weight_did_stop_changing }
  end

  def weight_did_stop_changing
    remove_gradient
    @timer.invalidate
    @incrementer.reset!
    weight_did_finish_editing
  end

  def add_notifications
    @keyboard_show = App.notification_center.observe UIKeyboardWillShowNotification do |notification|
      shift_frame(notification, :up)
    end

    @keyboard_hide = App.notification_center.observe UIKeyboardWillHideNotification do |notification|
      shift_frame(notification, :down)
    end
  end

  def add_gradient(direction)
    layer = HorizontalGradientLayer.layer(direction)
    layer.frame = @buttons.bounds
    @buttons.layer.insertSublayer(layer, atIndex: 0)
  end

  def remove_gradient
    @buttons.layer.sublayers[0].removeFromSuperlayer
  end

  def swipe(direction, expected_offset)
    other_direction = direction == :left ? :right : :left
    if self.view.origin.x == 0
      container.show_menu(other_direction)
    elsif self.view.origin.x == expected_offset
      container.hide_menu(direction)
    end
  end

  def weight_did_finish_editing
    @weight_text_field.resignFirstResponder
    App::Persistence['weight'] = @weight_text_field.text.to_f
  end

  def shift_frame(notification, direction)
    UIView.animation_chain(duration: notification.userInfo['UIKeyboardAnimationDurationUserInfoKey']) {
      @buttons.slide(direction, notification.userInfo['UIKeyboardFrameBeginUserInfoKey'].CGRectValue.size.height)
    }.start
  end

  # text field delegate methods
  def textFieldShouldReturn(text_field)
    weight_did_finish_editing
  end
end
