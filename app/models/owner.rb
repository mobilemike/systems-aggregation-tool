class Owner < ActiveRecord::Base
  has_one :scom_computer
  has_many :computers

  def to_param
    self.initials
  end
  
  def to_label
    self.initials
  end
  
  def first_name
    self.name.split[0]
  end
  
  def self.all_sorted_by_name
    self.find(:all, :order => :name)
  end
  
  def self.find_all_for_select
    self.all_sorted_by_name.map! {|o| [o.initials, o.initials]}.inspect
  end
  
end


# == Schema Information
#
# Table name: owners
#
#  id         :integer         primary key
#  name       :string(255)
#  initials   :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#

