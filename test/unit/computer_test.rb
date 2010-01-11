require 'test_helper'

class ComputerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Computer.new.valid?
  end
end


# == Schema Information
#
# Table name: computers
#
#  id               :integer         not null, primary key
#  fqdn             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  owner_id         :integer
#  disposition      :string(255)
#  ip               :integer(8)
#  mac              :string(255)
#  subnet_mask      :integer(8)
#  virtual          :boolean
#  serial_number    :string(255)
#  model            :string(255)
#  install_date     :datetime
#  cpu_count        :integer
#  cpu_speed        :integer
#  cpu_name         :string(255)
#  os_vendor        :string(255)
#  os_type          :string(255)
#  os_version       :string(255)
#  os_kernel_ver    :string(255)
#  mem_total        :integer
#  mem_free         :integer
#  mem_swap         :integer
#  last_logged_on   :string(255)
#  bios_name        :string(255)
#  bios_ver         :string(255)
#  ilo_ip           :integer(8)
#  hp_mgmt_ver      :string(255)
#  cpu_reaady       :float
#  host_computer_id :integer
#  mem_reservation  :integer
#  cpu_reservation  :integer
#  mem_baloon       :integer
#  vcpu_used        :float
#  vcpu_efficiency  :float
#

