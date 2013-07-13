class AvailablePlatesFormScreen < PM::FormotionScreen
  include HasContainer

  #stylesheet :plate_math
  #layout :settings do
    #@label = subview(UILabel, :label)
  #end

  def table_data
    {
      sections: [{
        rows: [{
          title: "Save",
          type: :submit
        }]
      }]
    }
  end

  def will_appear
    self.form.on_submit do |form|
      self.container.hide_menu(:left)
    end
  end
end
