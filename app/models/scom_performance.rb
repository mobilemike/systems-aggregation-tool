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
