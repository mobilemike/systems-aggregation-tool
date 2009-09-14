module ComputersHelper
    def health_column computer
      food_icon(computer)
    end
    
    def wsus_computer_column computer
      updates = 0
      span_class = "health-normal"
      if computer.wsus_computer
        span_class = case computer.wsus_computer.update_health
          when 1 then "health-normal"
          when 3 then "health-error"
        end
        updates = computer.wsus_computer.updates_outstanding
      end
      
      content_tag(:span, updates, :class => span_class)
    end
end
