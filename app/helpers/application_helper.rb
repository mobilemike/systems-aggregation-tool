# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def food_icon(options = {})
    options ||= {}
    id = ''
    health = case options
      when Integer
        options
      else
        id = options.id
        options.health
    end
           
    image_source = case health
      when 0 then "knob_message_16.gif"
      when 1 then "cabbage_16.gif"
      when 2 then "onion_16.gif"
      when 3 then "tomato_16.gif"
      when 4 then "cabbage_16.gif"
      when 5 then "tomato_16.gif"
    end
    
    image_tag(image_source, :alt => id, :class => 'health-icon')
  end
  
  def truncate_with_tip(text,length=30)
    if text.length > length
      content_tag(:span, truncate(text, length), :class => 'tip',
                  :title => text)
    else
      text
    end
  end
  
  def mb_to_human_size number
    number_to_human_size(number * 1048576)
  end
  
end
