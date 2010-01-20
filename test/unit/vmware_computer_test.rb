require 'test_helper'

class VmwareComputerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: vmware_computers
#
#  id               :integer         not null, primary key
#  computer_id      :integer
#  name             :string(255)
#  power            :integer
#  os               :string(255)
#  os_family        :string(255)
#  memory           :integer
#  cpu_count        :integer
#  nic_count        :integer
#  fqdn             :string(255)
#  ip               :string(255)
#  tools_status     :integer
#  tools_version    :integer
#  boot_time        :datetime
#  memory_overhead  :integer
#  description      :string(255)
#  host_computer_id :integer
#  type             :integer
#  vmotion          :integer
#  os_version       :string(255)
#  os_build         :integer
#  vendor           :string(255)
#  model            :string(255)
#  cpu_type         :string(255)
#  cpu_speed        :integer
#  hba_count        :integer
#  maintenance_mode :integer
#  cpu_health       :integer
#  memory_health    :integer
#  created_at       :datetime
#  updated_at       :datetime
#

