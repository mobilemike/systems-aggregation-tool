module PcsHelper
  
  def ep_dat_outdated_column pc
    updates = "-"
    span_class = "health-empty"
    
    if pc.in_epo?
      span_class = case pc.health_ep_dat
      when 0 then "health-normal"
      when 1..2 then "health-warning"
      when 3 then "health-error"
      end
      updates = pc.health_ep_dat
    end
    
    content_tag(:span, updates, :class => span_class)
  end
  
  def fqdn_column computer
    computer.name + content_tag(:span, "<wbr />." + computer.domain, :class => 'domain')
  end
  
  def in_ldap_column pc
    pc.in_ldap? ? food_icon(0) : "-"
  end
  
  def in_epo_column pc
    pc.in_epo? ? food_icon(0) : "-"
  end
  
  def in_sccm_column pc
    pc.in_sccm? ? food_icon(0) : "-"
  end
  
  def in_wsus_column pc
    pc.in_wsus? ? food_icon(0) : "-"
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
