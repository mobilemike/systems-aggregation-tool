class Owner < ActiveRecord::Base
  has_one :scom_computer
  has_many :computers

  def to_param
    self.initials
  end
  
  def to_label
    self.initials
  end
  
  def self.all_sorted_by_name
    self.find(:all, :order => :name)
  end
end
