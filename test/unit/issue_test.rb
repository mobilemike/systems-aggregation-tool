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
#  id          :integer         not null, primary key
#  identifier  :string(255)
#  category    :string(255)
#  text        :string(255)
#  source      :string(255)
#  computer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean
#

