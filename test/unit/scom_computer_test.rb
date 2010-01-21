require 'test_helper'

class ScomComputerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: scom_computers
#
#  id                       :integer         not null, primary key
#  bme                      :string(255)
#  fqdn                     :string(255)
#  ad_site                  :string(255)
#  ip                       :string(255)
#  ou                       :string(255)
#  health                   :integer
#  last_modified            :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  computer_id              :integer
#  owner_id                 :string(255)
#  virtual                  :boolean
#  model                    :string(255)
#  serial_number            :string(255)
#  bios_firmware            :string(255)
#  management_version       :string(255)
#  ilo_ip                   :string(255)
#  install_date             :datetime
#  cpus                     :integer
#  domain                   :string(255)
#  scom_cpu_perf_id         :integer
#  scom_memory_perf_id      :integer
#  os_version_number        :string(255)
#  memory                   :integer
#  os                       :string(255)
#  os_sp                    :integer
#  cores                    :integer
#  server_2008_install_type :string(255)
#

