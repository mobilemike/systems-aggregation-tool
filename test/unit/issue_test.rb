require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end




# == Schema Information
#
# Table name: issues
#
#  id          :integer         primary key
#  identifier  :string(255)
#  source      :string(255)
#  description :text
#  computer_id :integer
#  severity    :integer
#  active      :boolean
#  created_at  :timestamp
#  updated_at  :timestamp
#

