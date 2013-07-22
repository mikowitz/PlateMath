class SettingsScreen < PM::GroupedTableScreen
  include HasContainer

  def table_data
    [{
      title: 'Settings',
      cells: [
        { title: "Available Plates", action: :show_available_plates },
      ]
    }, {
      title: 'Recent Weights',
      cells: App::Persistence['recent_weights'].map {|weight| weight_row(weight) }
    }]
  end

  def show_available_plates
    container.container.show_menu(:left)
  end

  def weight_row(weight)
    {
      title: weight.to_s,
      action: :set_weight,
      arguments: { weight: weight }
    }
  end
end
