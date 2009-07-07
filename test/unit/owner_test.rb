require 'test_helper'

class OwnerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Owner.new.valid?
  end
end
