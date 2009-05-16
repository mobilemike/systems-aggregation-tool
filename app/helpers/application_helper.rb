# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def food_icon level
    case level
    when 1
      tag("img", { :src => "images/cabbage_32.png" })
    when 2
      tag("img", { :src => "images/onion_32.png" })
    when 3
      tag("img", { :src => "images/tomato_32.png" })
    when 4
      tag("img", { :src => "images/carrot_32.png" })
    end
  end
end
