module ComputersHelper
    def health_column computer
      food_icon(computer)
    end
    
    def wsus_computer_column computer
      updates = "N/A"
      span_class = "health-warning"
      if computer.wsus_computer
        span_class = case computer.wsus_computer.update_health
          when 1 then "health-normal"
          when 3 then "health-error"
        end
        updates = computer.wsus_computer.updates_outstanding
      end
      
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
      case computer.virtual?
      when true then "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
      else "<img src=\"#{ActionController::Base.relative_url_root}/images/server.png\" />"
      end
    end
    
    def avamar_column computer
      bytes_protected = "-"
      span_class = "health-empty"
      if computer.avamar_computer
        span_class = case computer.avamar_computer.health
          when 1 then "health-normal"
          when 2 then "health-warning"
          when 3 then "health-error"
        end
        bytes_protected = number_to_human_size(computer.avamar_computer.bytes_scanned)
      end
      
      content_tag(:span, bytes_protected, :class => span_class)
    end
    
    def retention_column computer
      computer.avamar_computer ? computer.avamar_computer.retention_policy.split[0] : "-"
    end
   
   def csv_header
     header = '"FQDN","Status","Health","WSUS","Owner","Virtual","IP","OS","Install Date","OU","Serial Number",'
     header += '"Model","Avamar Dataset","Avamar Schedule","Avamar Retention Policy",'
     header += '"Avamar MB Protected", "Avamar MB New"'
   end
   
   def csv_row c
     results = "\"#{c.fqdn}\""
     results += ",\"#{c.status}\""
     results += case c.health
                  when 1 then ',"Normal"'
                  when 2 then ',"Warning"'
                  when 3 then ',"Critical"'
                  else ',"-"'
                end
     results += ",#{c.wsus_computer ? c.wsus_computer.updates_outstanding : '"-"'}"
     results += ",\"#{c.owner ? c.owner.name : "-"}\""
     results += ",\"#{c.virtual? ? "Virtual" : "Physical"}\""
     results += ",\"#{c.ip}\""
     results += ",\"#{c.os}\""
     results += ",\"#{c.scom_computer ? c.scom_computer.install_date ? c.scom_computer.install_date.strftime("%m/%d/%Y %I:%M %p") : "-" : "-"}\""    
     results += ",\"#{c.scom_computer ? c.scom_computer.ou : "-"}\""
     results += ",\"#{c.scom_computer ? c.scom_computer.serial_number : "-"}\""
     results += ",\"#{c.scom_computer ? c.scom_computer.model : "-"}\""
     results += ",\"#{c.avamar_computer ? c.avamar_computer.dataset : "-"}\""
     results += ",\"#{c.avamar_computer ? c.avamar_computer.schedule : "-"}\""
     results += ",\"#{c.avamar_computer ? c.avamar_computer.retention_policy : "-"}\""
     results += ",#{c.avamar_computer ? (c.avamar_computer.bytes_scanned / 10485.76).round.to_f / 100 : '"-"'}"
     results += ",#{c.avamar_computer ? (c.avamar_computer.bytes_new / 10485.76).round.to_f / 100 : '"-"'}"
     return results
   end
    
end
