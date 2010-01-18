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
#  id                       :integer         not null, primary key
#  fqdn                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  owner_id                 :integer
#  disposition              :string(255)
#  bios_name                :string(255)
#  bios_ver                 :string(255)
#  cpu_count                :integer
#  cpu_name                 :string(255)
#  cpu_ready                :float
#  cpu_reservation          :integer
#  cpu_speed                :integer
#  description              :text
#  guest                    :boolean
#  host                     :boolean
#  host_computer_id         :integer
#  hp_mgmt_ver              :string(255)
#  ilo_ip_int               :integer
#  install_date             :datetime
#  ip_int                   :integer
#  last_logged_on           :string(255)
#  mac                      :string(255)
#  mem_balloon              :integer
#  mem_reservation          :integer
#  mem_swap                 :integer
#  mem_total                :integer
#  mem_used                 :integer
#  model                    :string(255)
#  os_64                    :boolean
#  os_edition               :string(255)
#  os_kernel_ver            :string(255)
#  os_name                  :string(255)
#  os_sp                    :integer
#  os_vendor                :string(255)
#  os_version               :string(255)
#  serial_number            :string(255)
#  subnet_mask_int          :integer
#  vcpu_efficiency          :float
#  vcpu_used                :float
#  health_ak_cpu            :integer
#  ak_cpu_last_modified     :datetime
#  health_ak_storage        :integer
#  ak_storage_last_modified :datetime
#  health_ak_mem            :integer
#  ak_mem_last_modified     :datetime
#  health_sc_state          :integer
#  sc_cpu_perf_id           :integer
#  sc_mem_perf_id           :integer
#

