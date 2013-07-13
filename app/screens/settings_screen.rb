class SettingsScreen < PM::GroupedTableScreen
  include HasContainer
  stylesheet :plate_math
  layout :settings do
    @label = subview(UILabel, :label)
  end

  def table_data
    [{
      title: 'Settings',
      cells: [
        { title: "Available Plates", action: :show_available_plates }
      ]
    }]
  end

  def show_available_plates
    container.container.show_menu(:left)
  end
end
