require 'test_helper'

class OwnerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Owner.new.valid?
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

