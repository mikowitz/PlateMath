class AvailablePlatesFormScreen < PM::FormotionScreen
  include HasContainer

  def table_data
    {
      sections: [{
        title: 'Available Weight Plates',
        rows: [
          {
            type: :static,
            title: 'Number of plate *pairs*',
            subtitle: 'blank is counted as unlimited'
          }
        ] + weight_form_rows
      }, {
        rows: [{
          title: "Save",
          type: :submit
        }]
      }]
    }
  end

  def weight_form_rows
    [45, 35, 25, 10, 5, 2.5, 1.25].map {|weight| form_element_for_weight(weight) }
  end

  def form_element_for_weight(weight)
    { 
      title: weight.to_s,
      key: weight.to_s,
      value: App::Persistence['available_plates'][weight.to_s],
      placeholder: '',
      type: :number
    }
  end

  def will_appear
    self.form.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder
      data = form.render
      App::Persistence['available_plates'] = data
      self.container.main_screen.main_screen.calculator.set_plate_counts(App::Persistence['available_plates'])
      self.container.main_screen.main_screen.incrementer = Incrementer.with_minimum_increment(App::Persistence['available_plates'])

      container.main_screen.main_screen.draw_plates(container.main_screen.main_screen.weight_text_field.text.to_f)

      self.container.hide_menu(:left)
    end
  end
end
