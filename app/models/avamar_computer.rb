class AvamarComputer < ActiveRecord::Base
  belongs_to :computers
  
  def health
    case self.status_code_summary
      when /failed/ then 3
      when /successfully/ then 1
      else 2
    end
  end
  
end
