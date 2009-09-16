class Owner < ActiveRecord::Base
  has_one :scom_computer
  
  def to_label
    self.initials
  end
end
