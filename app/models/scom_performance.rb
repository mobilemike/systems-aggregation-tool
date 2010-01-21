class ScomPerformance < ActiveRecord::Base
  establish_connection :scom_db
  set_table_name "performancedataallview"
  
  def self.data
    data = []
    find(:all).each do |record|
      data << {:x => record.TimeSampled, :y => record.SampleValue}
    end
    
    data
  end
  
end

# == Schema Information
#
# Table name: performancedataallview
#
#  PerformanceDataId           :string          not null
#  PerformanceSourceInternalId :integer(4)      not null
#  SampleValue                 :float
#  TimeSampled                 :datetime        not null
#  TimeAdded                   :datetime        not null
#

