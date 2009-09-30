class ScomComputer < ActiveRecord::Base
  belongs_to :computer
  belongs_to :owner
  has_many :scom_cpu_perf, :class_name => "ScomPerformance", :foreign_key => "PerformanceSourceInternalId",
          :primary_key => "scom_cpu_perf_id"
end
