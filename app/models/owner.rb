class Owner < ActiveRecord::Base
  has_one :scom_computer
  has_many :computers
  
  def to_label
    self.initials
  end
end

# == Schema Information
#
# Table name: owners
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  initials   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

