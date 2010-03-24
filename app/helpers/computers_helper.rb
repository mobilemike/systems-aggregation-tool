module ComputersHelper
  
  
  def av_overview_column computer
    span_class = "health-empty"
    
    if computer.in_avamar?
      span_class = case computer.health_av_last
        when 1 then "health-normal"
        when 2 then "health-warning"
        when 3 then "health-error"
      end
    end
    
    content_tag(:span, computer.av_scanned ? content_tag(:span,
                                                  mb_to_human_size(computer.av_scanned),
                                                  :class => 'tip',
                                                  :title => computer.av_message) : '-', 
                :class => span_class)
  end
  
  def av_new_column computer
    span_class = "health-empty"
    
    if computer.in_avamar?
      span_class = case computer.av_new
        when 0 then "health-warning"
        else "health-normal"
      end
    end
    
    content_tag(:span, computer.av_new ? mb_to_human_size(computer.av_new) : '-', :class => span_class)
  end
  
  def av_scanned_column computer
    span_class = "health-empty"
    
    if computer.in_avamar?
      span_class = case computer.av_scanned
        when 0 then "health-error"
        else "health-normal"
      end
    end
    
    content_tag(:span, computer.av_scanned ? mb_to_human_size(computer.av_scanned) : '-', :class => span_class)
  end
  
  def av_message_column computer
    span_class = "health-empty"
    
    if computer.in_avamar?
      span_class = case computer.health_av_last
        when 1 then "health-normal"
        when 2 then "health-warning"
        when 3 then "health-error"
      end
    end
    
    content_tag(:span, computer.av_message ? truncate_with_tip(computer.av_message) : "-", :class => span_class)
  end
  
  def company_column computer
    record = computer
    column = active_scaffold_config.columns[:company]
    collection = [['Unknown', 'Unknown'], ['RMR', 'RMR'], ['Five Star', 'Five Star',], ['Shared', 'Shared']].inspect
    active_scaffold_inplace_collection_edit(record, column, collection)
  end
  
  def cpu_ready_column computer
    computer.cpu_ready ? number_with_precision(computer.cpu_ready, 2) + "%" : "-"
  end
    
  def cpu_reservation_column computer
    computer.cpu_reservation ? computer.cpu_reservation.to_s + " Mhz" : "-"
  end
  
  def description_column computer
    computer.description ? truncate_with_tip(computer.description) : "-"
  end
  
  def fqdn_column computer
    computer.name + content_tag(:span, "<wbr />." + computer.domain, :class => 'domain')
  end
  
  def guest_column computer
    case computer.guest
    when true then "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    else "<img src=\"#{ActionController::Base.relative_url_root}/images/server.png\" />"
    end
  end
  
  def health_av_last_column computer
    food_icon(computer.health_av_last)
  end
  
  def health_column computer
    food_icon(computer)
  end
  
  def ilo_ip_column computer
    computer.ilo_ip_int ? link_to(computer.ilo_ip, "https:/#{computer.ilo_ip}", :popup => true) : "-"
  end
  
  def mem_reservation_column computer
    computer.mem_reservation ? mb_to_human_size(computer.mem_reservation) : "-"
  end
  
  def mem_balloon_column computer
    computer.mem_balloon ? mb_to_human_size(computer.mem_balloon) : "-"
  end
  
  def status_column computer
    record = computer
    column = active_scaffold_config.columns[:status]
    collection = Computer.aasm_states_for_select.map {|k,v| [k, v.capitalize]}.inspect
    active_scaffold_inplace_collection_edit(record, column, collection)
  end
  
  def us_outstanding_column computer
    updates = "N/A"
    span_class = "health-warning"
    
    if computer.us_last_sync
      span_class = case computer.health_us_outstanding
      when 1 then "health-normal"
      when 3 then "health-error"
      end
      updates = computer.us_outstanding
    end
    
    content_tag(:span, updates, :class => span_class)
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
  
  def csv_header
    header = '"FQDN","Owner","Status","Company","Description","Health","WSUS","Virtual","Host","IP",'
    header += '"CPU Speed","CPU Count","RAM Total","RAM Used","Disk Total","Disk Free","OS",'
    header += '"Install Date","Serial Number","Make","Model","Dataset","Schedule",'
    header += '"Retention","MB Protected","MB New"'
  end
  
  def csv_row c
    results = "\"#{c.fqdn}\""
    results += ",\"#{c.owner ? c.owner.name : "" }\""
    results += ",\"#{c.status}\""
    results += ",\"#{c.company}\""
    results += ",\"#{c.description}\""
    results += case c.health
                 when 1 then ',"Normal"'
                 when 2 then ',"Warning"'
                 when 3 then ',"Critical"'
                 else ',""'
               end
    results += ",#{c.us_outstanding}"
    results += ",\"#{c.guest ? "Virtual" : "Physical"}\""
    results += ",\"#{c.host_computer ? c.host_computer.name : ""}\""
    results += ",\"#{c.ip}\""
    results += ",\"#{c.cpu_speed}\""
    results += ",\"#{c.cpu_count}\""
    results += ",\"#{c.mem_total ? mb_to_human_size(c.mem_total) : ""}\""
    results += ",\"#{c.mem_used ? mb_to_human_size(c.mem_used) : ""}\""
    results += ",\"#{c.total_disk ? mb_to_human_size(c.total_disk) : ""}\""
    results += ",\"#{c.free_disk ? mb_to_human_size(c.free_disk) : ""}\""
    results += ",\"#{c.os_long}\""
    results += ",\"#{c.install_date ? c.install_date.strftime("%m/%d/%Y %I:%M %p") : "" }\""    
    results += ",\"#{c.serial_number}\""
    results += ",\"#{c.make}\""    
    results += ",\"#{c.model}\""
    results += ",\"#{c.av_dataset}\""
    results += ",\"#{c.av_schedule}\""
    results += ",\"#{c.av_retention}\""
    results += ",#{c.av_scanned}"
    results += ",#{c.av_new}"
    return results
  end
  
  def all_csv_header
    Computer.column_names.sort.map {|n| "\"#{n}\""}.join(',')
  end
  
  def all_csv_row c
    c.attributes.sort.map {|k,v| "\"#{v.to_s}\""}.join(',')
  end
   
end
