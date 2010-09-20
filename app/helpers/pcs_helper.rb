module PcsHelper
  
  def ep_dat_outdated_column pc
    age = "?"
    span_class = "health-error"
    
    if pc.in_epo?
      span_class = case pc.health_ep_dat
      when 0 then "health-normal"
      when 2 then "health-warning"
      when 3 then "health-error"
      end
      age = pc.ep_dat_outdated < 90 ? pc.ep_dat_outdated : "!"
    end
    
    content_tag(:span, age, :class => span_class)
  end
  
  def fqdn_column computer
    computer.name + content_tag(:span, "<wbr />." + computer.domain, :class => 'domain')
  end
  
  def in_ldap_column pc
    pc.in_ldap? ? food_icon(0) : food_icon(5)
  end
  
  def in_sccm_column pc
    pc.in_sccm? ? food_icon(0) : food_icon(5)
  end
  
  def us_outstanding_column computer
    updates = "?"
    span_class = "health-error"
    
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
    header = '"FQDN","Company","Patches",'
    header += '"SUS Group","DAT Age","IP","CPU Speed","CPU Count","RAM Total","RAM Used",'
    header += '"Disk Total","Disk Free","OS","Make",'
    header += '"Model","ePO","AD","SCCM","WSUS"'
  end
  
  def csv_row c
    results = "\"#{c.fqdn}\""
    results += ",\"#{c.company}\""
    results += ",#{c.us_outstanding}"
    results += ",\"#{c.us_group_name}\""
    results += ",\"#{c.ep_dat_outdated}\""
    results += ",\"#{c.ip}\""
    results += ",\"#{c.cpu_speed}\""
    results += ",\"#{c.cpu_count}\""
    results += ",\"#{c.mem_total}\""
    results += ",\"#{c.mem_used}\""
    results += ",\"#{c.disk_total}\""
    results += ",\"#{c.disk_free}\""
    results += ",\"#{c.os_long}\""
    results += ",\"#{c.make}\""    
    results += ",\"#{c.model}\""
    results += ",\"#{c.in_epo? ? "Yes" : ""}\""
    results += ",\"#{c.in_ldap? ? "Yes" : ""}\""
    results += ",\"#{c.in_sccm? ? "Yes" : ""}\""
    results += ",\"#{c.in_wsus? ? "Yes" : ""}\""
    return results
  end
  
  def all_csv_header
    Pc.column_names.sort.map {|n| "\"#{n}\""}.join(',')
  end
  
  def all_csv_row pc
    pc.attributes.sort.map {|k,v| "\"#{v.to_s}\""}.join(',')
  end
   
end
