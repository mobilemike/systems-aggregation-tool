require 'test_helper'

class WsusComputerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: wsus_computers
#
#  id                     :integer         not null, primary key
#  computer_id            :integer
#  fqdn                   :string(255)
#  last_sync              :datetime
#  last_status            :datetime
#  last_reboot            :datetime
#  ip_address             :string(255)
#  os_major               :integer
#  os_minor               :integer
#  os_build               :integer
#  os_sp                  :integer
#  make                   :string(255)
#  model                  :string(255)
#  bios_ver               :string(255)
#  bios_name              :string(255)
#  bios_date              :date
#  processor_type         :string(255)
#  wsus_created_at        :datetime
#  client_ver             :string(255)
#  updates_unknown        :integer
#  updates_not_installed  :integer
#  updates_downloaded     :integer
#  updates_installed      :integer
#  updates_failed         :integer
#  updates_pending_reboot :integer
#  created_at             :datetime
#  updated_at             :datetime
#  computer_hash          :string(255)
#  updates_approved       :integer
#

