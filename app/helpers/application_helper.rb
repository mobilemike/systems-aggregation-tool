# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def food_icon level
    case level
    when 1
      image_tag("cabbage_32.png")
    when 2
      image_tag("onion_32.png")
    when 3
      image_tag("tomato_32.png")
    when 4
      image_tag("carrot_32.png")
    end
  end
end
