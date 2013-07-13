class MenuContainerScreen < PM::Screen
  OFFSET = 270
  stylesheet :menu_container

  attr_accessor :main_screen, :right_menu, :left_menu

  def on_create(args={})
    @main_screen = args[:main_screen]
    @right_menu = args[:right_menu]
    @left_menu = args[:left_menu]
  end

  def will_appear
    display_main_view
    set_left_menu_to_closed
    set_right_menu_to_closed
    @right_swipe = @main_screen.view.on_swipe(:right) do |swipe|
      if @main_screen.view.origin.x == 0 && @left_menu.present?
        show_menu(:left)
      elsif @main_screen.view.origin.x == -OFFSET
        hide_menu(:right)
      end
    end
    @left_swipe = @main_screen.view.on_swipe(:left) do |swipe|
      if @main_screen.view.origin.x == 0 && @right_menu.present?
        show_menu(:right)
      elsif @main_screen.view.origin.x == OFFSET
        hide_menu(:left)
      end
    end
  end

  def set_left_menu_to_closed
    return unless @left_menu
    frame = self.view.bounds
    frame.size.width = 0
    @left_menu.view.frame = frame
    unless self.view.subviews.include?(@left_menu.view)
      self.view.insertSubview(@left_menu.view, atIndex: 0)
    end
  end

  def set_right_menu_to_closed
    return unless @right_menu
    frame = self.view.bounds
    frame.size.width = 0
    frame.origin.x = self.view.bounds.width
    @right_menu.view.frame = frame
    unless self.view.subviews.include?(@right_menu.view)
      self.view.insertSubview(@right_menu.view, atIndex: 0)
    end
  end

  def display_main_view
    @main_screen.view.frame = self.view.bounds
    unless self.view.subviews.include?(@main_screen.view)
      self.view.insertSubview(@main_screen.view, atIndex: 0)
    end
  end

  def hide_menu(menu_side)
    UIView.animation_chain(duration: 0.3) {
      display_main_view
    }.and_then(duration: 0.1) {
      send("set_#{menu_side}_menu_to_closed")
    }.start
  end

  def show_menu(menu_side)
    return unless menu_on(menu_side).present?
    main_direction = menu_side == :left ? :right : :left
    @main_screen.view.slide main_direction, OFFSET
    menu_on(menu_side).view.frame = self.view.bounds
  end

  def menu_on(menu_side)
    send("#{menu_side}_menu")
  end
end
