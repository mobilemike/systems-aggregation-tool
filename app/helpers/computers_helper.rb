module ComputersHelper
    def health_column computer
      food_icon(computer.health)
    end
    
    def owner_column computer
      computer.owner.initials
    end
    
    
end
