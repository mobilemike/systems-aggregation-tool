class Owner < ActiveRecord::Base
  has_one :scom_computer
  has_many :computers
  
  def to_label
    self.initials
  end
end
