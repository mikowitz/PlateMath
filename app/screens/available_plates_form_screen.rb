class AvailablePlatesFormScreen < PM::FormotionScreen
  include HasContainer

  def table_data
    {
      sections: [{
        title: 'Available Weight Plates',
        rows: [
          {
            type: :static,
            title: 'Enter number of plate *pairs*',
            subtitle: 'blank values will be counted as unlimited'
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
      key: :"weight_#{weight}",
      value: App::Persistence['available_plates'][weight.to_s],
      placeholder: '',
      type: :number
    }
  end

  def will_appear
    self.form.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder
      data = Hash[form.render.map do |key, value|
        [key.to_s.sub(/weight_/, ''), value]
      end]
      App::Persistence['available_plates'] = data
      self.container.hide_menu(:left)
    end
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
  end
end
