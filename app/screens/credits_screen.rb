class CreditsScreen < PM::Screen
  include HasContainer

  stylesheet :credits_view
  layout :credits do
    subview(UILabel, :title_label, text: 'PlateMath was created by')
    @name = subview(UILabel, :credits_name, attributedText: 'Michael Berkowitz'.underline)
    subview(UILabel, :copyright_label, text: '© 2013 Michael Berkowitz')
  end

  def will_appear
    self.view.backgroundColor = :white.uicolor
    self.view.on_tap do |tap|
      touch_location = tap.locationInView(self.view)
      if touch_location.inside?(@name.frame)
        'http://songsaboutsnow.com'.nsurl.open
      end
    end
  end
end
