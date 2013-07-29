class MenuContainerScreen < PM::Screen
  include HasContainer
  stylesheet :menu_container

  attr_accessor :main_screen, :right_menu, :left_menu

  def shouldAutorotate
    false
  end

  def on_create(args={})
    @main_screen = args[:main_screen]
    @right_menu = args[:right_menu]
    @left_menu = args[:left_menu]
  end

  def will_appear
    display_main_screen
    main_screen.container = self
    main_screen.view.layer.masksToBounds = false
    main_screen.view.layer.shadowColor = :black.uicolor.CGColor
    main_screen.view.layer.shadowOpacity = 0.5
    self.view.insertSubview(@main_screen.view, atIndex: 0)
    if left_menu.present?
      set_left_menu_to_closed
      left_menu.container = self
      self.view.insertSubview(@left_menu.view, atIndex: 0)
    end
    if right_menu.present?
      set_right_menu_to_closed
      right_menu.container = self
      self.view.insertSubview(@right_menu.view, atIndex: 0)
    end
  end

  def set_left_menu_to_closed
    return unless @left_menu
    frame = self.view.bounds
    frame.size.width = 0
    @left_menu.view.frame = frame
  end

  def set_right_menu_to_closed
    return unless @right_menu
    frame = self.view.bounds
    frame.size.width = 0
    frame.origin.x = self.view.bounds.width
    @right_menu.view.frame = frame
  end

  def display_main_screen
    @main_screen.view.frame = self.view.bounds
  end

  def hide_menu(menu_side)
    UIView.animation_chain(duration: 0.3) {
      display_main_screen
    }.and_then(duration: 0.1) {
      send("set_#{menu_side}_menu_to_closed")
    }.start
  end

  def show_menu(menu_side)
    return unless menu_closed_on?(menu_side)
    slide_direction = menu_side == :left ? :right : :left
    @main_screen.view.layer.shadowOffset = CGSizeMake((menu_side == :left ? -5 : 5 ), 0)
    @main_screen.view.slide slide_direction, OFFSET
    frame = self.view.bounds
    if menu_side == :left && menu_on(menu_side).is_a?(AvailablePlatesFormScreen)
      frame.size.width = frame.size.width - 50
    end
    menu_on(menu_side).view.frame = frame
  end

  def menu_on(menu_side)
    send("#{menu_side}_menu")
  end

  def menu_closed_on?(menu_side)
    menu_on(menu_side).present? && menu_on(menu_side).view.frame.width == 0
  end
end
