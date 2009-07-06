class AvamarComputer < ActiveRecord::Base
  belongs_to :computers
  
  def health
    1
  end
end
