class SettingsScreen < PM::GroupedTableScreen
  include HasContainer

  def table_data
    [{
      title: 'Settings',
      cells: [
        { title: "Available Plates", action: :show_available_plates },
        { title: 'Bar Weight', cell_identifier: 'BarWeightCellIdentifier', cell_class: BarWeightCell }
      ]
    }, {
      title: 'Recent Weights',
      cells: possible_recent_weights.map {|weight| weight_row(weight) }
    }]
  end

  def possible_recent_weights
    App::Persistence['recent_weights'].select{|weight| weight >= App::Persistence['bar_weight']}
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

class BarWeightCell < UITableViewCell
  SEGMENTS = %w( 25 45 )
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    selectionStyle = UITableViewCellSelectionStyleNone
    @switch = UISegmentedControl.alloc.initWithItems(SEGMENTS)
    @switch.selectedSegmentIndex = SEGMENTS.index(App::Persistence['bar_weight'].to_s)
    frame = @switch.frame
    frame.origin = SugarCube::CoreGraphics.Point(152, 7)
    frame.size = SugarCube::CoreGraphics.Size(60, 28)
    @switch.frame = frame
    @switch.tintColor = :gray.uicolor

    @switch.on(:change) do
      bar_weight = SEGMENTS[@switch.selectedSegmentIndex]
      App::Persistence['bar_weight'] = bar_weight.to_i
      App.delegate.home_screen.main_screen.main_screen.change_bar_weight
    end

    self.contentView.addSubview @switch
    self
  end
end
