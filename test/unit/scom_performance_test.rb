require 'test_helper'

class ScomPerformanceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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

