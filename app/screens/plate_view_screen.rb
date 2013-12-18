class PlateViewScreen < PM::Screen
  include HasContainer
  include BW::KVO

  attr_accessor :weight_text_field, :calculator, :incrementer

  stylesheet :plate_view
  layout :plate_view do
    @buttons = subview(UIView, :buttons) do
      @left_button = subview(UIButton, :left_button)
      @right_button = subview(UIButton, :right_button)
      @weight_text_field = subview(UITextField, :weight_text_field)
    end
    @plate_label = subview(UILabel, :plate_label)
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
    @weight_text_field.text = App::Persistence['recent_weights'].first.to_s
    @weight_text_field.delegate = self
    @incrementer = Incrementer.with_minimum_increment(App::Persistence['available_plates'])

    @calculator = PlateCalculator.new(App::Persistence['bar_weight'], App::Persistence['available_plates'])

    self.view.on_tap { weight_did_finish_editing }

    observe(@weight_text_field, :text) do |old_val, new_val|
      draw_plates(new_val.to_f)
    end
    draw_plates(@weight_text_field.text.to_f)
  end

  def draw_plates(weight)
    plates = @calculator.plates(weight)
    @plate_label.text = plates.join(' - ')
    @bar_view.subviews.each do |subview|
      if subview.is_a?(PlateView)
        subview.removeFromSuperview
      end
    end
    right_x = 211
    left_x = 110
    plates.each do |plate_weight|
      plate = PlateView.alloc.initWithWeight(plate_weight, atX: right_x)
      @bar_view.addSubview plate
      right_x += (plate.frame.width + 1)
      left_x -= (plate.frame.width + 1)
      plate = PlateView.alloc.initWithWeight(plate_weight, atX: left_x)
      @bar_view.addSubview plate
    end
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
    new_weight = [new_weight, App::Persistence['bar_weight']].max
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
    persist_weight
  end

  def change_bar_weight
    @calculator = PlateCalculator.new(App::Persistence['bar_weight'], App::Persistence['available_plates'])
    next_possible_weight = App::Persistence['recent_weights'].find{|weight| weight >= App::Persistence['bar_weight']}
    @weight_text_field.text = next_possible_weight.to_s
    draw_plates(next_possible_weight)
    container.hide_menu(:left)
    persist_weight
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

  def persist_weight
    App::Persistence['recent_weights'] = (App::Persistence['recent_weights'].dup.unshift(@weight_text_field.text.to_f)).uniq[0..25]
    self.container.left_menu.update_table_data
  end
end
