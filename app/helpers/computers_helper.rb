module ComputersHelper
  
  def health_column computer
    food_icon(computer)
  end
  
  def us_outstanding_column computer
    updates = "N/A"
    span_class = "health-warning"
    
    span_class = case computer.us_health
    when 1 then "health-normal"
    when 3 then "health-error"
    end
    updates = computer.us_outstanding
    
    content_tag(:span, updates, :class => span_class)
  end
  
  def status_column computer
    record = computer
    column = active_scaffold_config.columns[:status]
    collection = Computer.aasm_states_for_select.map {|k,v| [k, v.capitalize]}.inspect
    active_scaffold_inplace_collection_edit(record, column, collection)
  end
  
  def active_scaffold_inplace_collection_edit(record, column, collection)
    formatted_column = record.send(column.name)
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
 
  
  def virtual_column computer
    case computer.virtual
    when true then "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    else "<img src=\"#{ActionController::Base.relative_url_root}/images/server.png\" />"
    end
  end
  
  def av_scanned_column computer
    bytes_protected = "-"
    span_class = "health-empty"
    span_class = case computer.av_health
      when 1 then "health-normal"
      when 2 then "health-warning"
      when 3 then "health-error"
    end
    bytes_protected = number_to_human_size(computer.av_scanned)
   
    content_tag(:span, bytes_protected, :class => span_class)
  end
  
  
  def csv_header
    header = '"FQDN","Status","Health","WSUS","Owner","Virtual","IP","OS","Install Date","Serial Number",'
    header += '"Make","Model","Dataset","Schedule","Retention",'
    header += '"MB Protected", "MB New"'
  end
  
  def csv_row c
    results = "\"#{c.fqdn}\""
    results += ",\"#{c.status}\""
    results += case c.health
                 when 1 then ',"Normal"'
                 when 2 then ',"Warning"'
                 when 3 then ',"Critical"'
                 else ',""'
               end
    results += ",#{c.us_outstanding}"
    results += ",\"#{c.owner ? c.owner.name}\""
    results += ",\"#{c.virtual ? "Virtual" : "Physical"}\""
    results += ",\"#{c.ip}\""
    results += ",\"#{c.os_long}\""
    results += ",\"#{c.install_date ? c.install_date.strftime("%m/%d/%Y %I:%M %p")}\""    
    results += ",\"#{c.serial_number}\""
    results += ",\"#{c.make}\""    
    results += ",\"#{c.model}\""
    results += ",\"#{c.av_dataset}\""
    results += ",\"#{c.av_schedule}\""
    results += ",\"#{c.av_retention\}\""
    results += ",#{c.av_scanned}"
    results += ",#{c.av_new}"
    return results
  end
   
end
