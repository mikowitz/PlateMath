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

  def set_weight(args={})
    if args[:weight]
      container.main_screen.weight_text_field.text = args[:weight].to_s
      container.hide_menu(:left)
      container.main_screen.persist_weight
    end
  end
end
