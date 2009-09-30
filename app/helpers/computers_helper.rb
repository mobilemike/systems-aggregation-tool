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
    
    def virtual_column computer
      case computer.virtual?
      when true then "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
      else "<img src=\"#{ActionController::Base.relative_url_root}/images/server.png\" />"
      end
    end
    
end
