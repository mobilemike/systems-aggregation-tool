module ComputersHelper
  
  
  def av_overview_column computer
    span_class = "health-empty"
    
    if computer.in_avamar?
      span_class = case computer.health_av_last
        when 0 then "health-normal"
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
        when 0 then "health-normal"
        when 2 then "health-warning"
        when 3 then "health-error"
      end
    end
    
    content_tag(:span, computer.av_message ? truncate_with_tip(computer.av_message) : "-", :class => span_class)
  end
  
  def company_column computer
    record = computer
    column = active_scaffold_config.columns[:company]
    collection = [['Unknown', 'Unknown'], ['RMR', 'RMR'], ['Five Star', 'Five Star',],
                  ['Shared', 'Shared'], ['ILC', 'ILC']].inspect
    active_scaffold_inplace_collection_edit(record, column, collection, computer.company)
  end
  
  def cpu_ready_column computer
    computer.cpu_ready ? number_with_precision(computer.cpu_ready, 2) + "%" : "-"
  end
    
  def cpu_reservation_column computer
    computer.cpu_reservation ? computer.cpu_reservation.to_s + " Mhz" : "-"
  end
  
  def description_column computer
    if computer.in_ldap?
      computer.description ? truncate_with_tip(computer.description) : "-"
    else
      record = computer
      column = active_scaffold_config.columns[:description]
      active_scaffold_inplace_edit(record, column, computer.description ? truncate_with_tip(computer.description) : "-")
    end
  end
  
  def ep_dat_outdated_column computer
    updates = "-"
    span_class = "health-empty"
    
    if computer.in_epo?
      span_class = case computer.health_ep_dat
      when 0 then "health-normal"
      when 1..2 then "health-warning"
      when 3 then "health-error"
      end
      updates = computer.health_ep_dat
    end
    
    content_tag(:span, updates, :class => span_class)
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
  
  def owner_initials_column computer
    case computer.in_scom?
    when true
      computer.owner ? computer.owner_initials : "-"
    else
      record = computer
      column = active_scaffold_config.columns[:owner_initials]
      collection = Owner.find_all_for_select
      active_scaffold_inplace_collection_edit(record, column, collection, computer.owner ? computer.owner_initials : "-")
    end
  end
  
  def status_column computer
    case computer.in_scom?
    when true
      computer.status
    else
      record = computer
      column = active_scaffold_config.columns[:status]
      collection = Computer.aasm_states_for_select.map {|k,v| [k, v.humanize]}.inspect
      active_scaffold_inplace_collection_edit(record, column, collection, computer.status)
    end
  end
  
  def sc_uptime_percentage_column computer
    uptime = "-"

    if computer.sc_uptime_percentage?
      span_class = case computer.sc_uptime_percentage
      when (-1.0/0)..90 then "health-error"
      when 90..98 then "health-warning"
      when 98..(1.0/0) then "health-normal"
      end
      uptime = number_with_precision(computer.sc_uptime_percentage, :precision => 0) + "%"
    end

    content_tag(:span, uptime, :class => span_class)
  end
  
  def us_outstanding_column computer
    updates = "N/A"
    span_class = "health-warning"
    
    if computer.us_last_sync
      span_class = case computer.health_us_outstanding
      when 0 then "health-normal"
      when 3 then "health-error"
      end
      updates = computer.us_outstanding
    end
    
    content_tag(:span, updates, :class => span_class)
  end
  
  
  def csv_header
    header = '"FQDN","Owner","Status","Company","Description","Health","Uptime","Patches",'
    header += '"SUS Group","Virtual","Host","IP","CPU Speed","CPU Count","RAM Total","RAM Used",'
    header += '"Disk Total","Disk Free","OS","Install Date","Serial Number","Make",'
    header += '"Model","Dataset","Schedule","Retention","MB Protected","MB New"'
  end
  
  def csv_row c
    results = "\"#{c.fqdn}\""
    results += ",\"#{c.owner ? c.owner.name : "" }\""
    results += ",\"#{c.status}\""
    results += ",\"#{c.company}\""
    results += ",\"#{c.description}\""
    results += case c.health
                 when 0 then ',"Normal"'
                 when 1 then ',"Info"'
                 when 2 then ',"Warning"'
                 when 3 then ',"Critical"'
                 else ',""'
               end
    results += ",\"#{c.sc_uptime_percentage? ? number_with_precision(c.sc_uptime_percentage, :precision => 2) + "%" : ""}\""
    results += ",#{c.us_outstanding}"
    results += ",\"#{c.us_group_name}\""
    results += ",\"#{c.guest ? "Virtual" : "Physical"}\""
    results += ",\"#{c.host_computer ? c.host_computer.name : ""}\""
    results += ",\"#{c.ip}\""
    results += ",\"#{c.cpu_speed}\""
    results += ",\"#{c.cpu_count}\""
    results += ",\"#{c.mem_total}\""
    results += ",\"#{c.mem_used}\""
    results += ",\"#{c.total_disk}\""
    results += ",\"#{c.free_disk}\""
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
