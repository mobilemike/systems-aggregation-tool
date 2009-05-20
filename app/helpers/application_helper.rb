# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def food_icon level
    case level
    when 0
      image_tag("knob_message_32.gif")     
    when 1
      image_tag("cabbage_32.gif")
    when 2
      image_tag("onion_32.gif")
    when 3
      image_tag("tomato_32.gif")
    when 4
      image_tag("cabbage_light_32.gif")
    when 5
      image_tag("tomato_light_32.gif")
    end
  end
end
