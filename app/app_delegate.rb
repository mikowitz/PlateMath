class AppDelegate < PM::Delegate
  def on_load(app, options)
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
