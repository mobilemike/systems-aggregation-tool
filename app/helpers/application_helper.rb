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
  
  def truncate_with_tip(text)
    if text.length > 30
      content_tag(:span, truncate(text, 30), :class => 'tip',
                  :title => text)
    else
      text
    end
  end
  
  def mb_to_human_size number
    number_to_human_size(number * 1048576)
  end
  
  
  def active_scaffold_inplace_edit(record, column, formatted_column)
    id_options = {:id => record.id.to_s, :action => 'update_column', :name => column.name.to_s}
    tag_options = {:tag => "span", :id => element_cell_id(id_options), :class => "in_place_editor_field"}
    in_place_editor_options = {:url => {:controller => params_for[:controller], :action => "update_column", :column => column.name, :id => record.id.to_s},
     :with => params[:eid] ? "Form.serialize(form) + '&eid=#{params[:eid]}'" : nil,
     :click_to_edit_text => as_(:click_to_edit),
     :cancel_text => as_(:cancel),
     :loading_text => as_(:loading),
     :save_text => as_(:update),
     :saving_text => as_(:saving),
     :options => "{method: 'post'}",
     :script => true}.merge(column.options)
    content_tag(:span, formatted_column, tag_options) + in_place_editor(tag_options[:id], in_place_editor_options)
  end
  
  def active_scaffold_inplace_collection_edit(record, column, collection, formatted_column)
    id_options = {:id => record.id.to_s, :action => 'update_column', :name => column.name.to_s}
    tag_options = {:id => element_cell_id(id_options), :class => "in_place_editor_field"}
    in_place_collection_editor_options = {:url => {:controller => params_for[:controller],
                                                   :action => "update_column",
                                                   :column => column.name,
                                                   :id => record.id.to_s},
                                          :with => params[:eid] ? "Form.serialize(form) + '&eid=#{params[:eid]}'" : nil,
                                          :collection => collection,
                                          :click_to_edit_text => as_(:click_to_edit),
                                          :cancel_text => as_(:cancel),
                                          :loading_text => as_(:loading),
                                          :save_text => as_(:update),
                                          :saving_text => as_(:saving),
                                          :options => "{method: 'post'}",
                                          :script => true}.merge(column.options)
    content_tag(:span, formatted_column, tag_options) + in_place_collection_editor(tag_options[:id], in_place_collection_editor_options)
  end
  
end
