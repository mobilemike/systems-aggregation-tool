require 'test_helper'

class ComputerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Computer.new.valid?
  end
end
