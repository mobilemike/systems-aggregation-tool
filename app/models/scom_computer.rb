class ScomComputer < ActiveRecord::Base
  belongs_to :computer
  
  def health_as_word
    case health
    when 1
      "OK"
    when 2
      "Warning"
    when 3
      "Error"
    end
  end
end
