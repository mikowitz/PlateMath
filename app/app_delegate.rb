class AppDelegate < PM::Delegate
  def on_load(app, options)
    App::Persistence['available_plates'] ||= {}
    App::Persistence['recent_weights'] ||= [45.0]
    App::Persistence['bar_weight'] ||= 45.0
    open MenuContainerScreen.new(
      main_screen: MenuContainerScreen.new(
        main_screen: PlateViewScreen.new,
        left_menu: SettingsScreen.new,
        right_menu: CreditsScreen.new
      ),
      left_menu: AvailablePlatesFormScreen.new
    )
  end
end
