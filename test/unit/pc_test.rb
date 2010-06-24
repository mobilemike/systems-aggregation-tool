require 'test_helper'

class PcTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: pcs
#
#  id                :integer         not null, primary key
#  fqdn              :string(255)
#  cpu_speed         :integer
#  cpu_count         :integer
#  ip_int            :integer
#  last_logged_on    :string(255)
#  mac               :string(255)
#  make              :string(255)
#  mem_total         :integer
#  mem_used          :integer
#  model             :string(255)
#  os_edition        :string(255)
#  os_sp             :string(255)
#  os_version        :string(255)
#  serial_number     :string(255)
#  subnet_mask_int   :integer
#  ep_last_update    :datetime
#  ep_dat_version    :integer
#  ep_dat_outdated   :integer
#  company           :string(255)     default("Unknown")
#  in_epo            :boolean
#  in_wsus           :boolean
#  in_ldap           :boolean
#  in_sccm           :boolean
#  us_group_name     :string(255)
#  disk_total        :integer
#  disk_free         :integer
#  us_unknown        :integer         default(0)
#  us_not_installed  :integer         default(0)
#  us_downloaded     :integer         default(0)
#  us_installed      :integer         default(0)
#  us_failed         :integer         default(0)
#  us_pending_reboot :integer         default(0)
#  us_approved       :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

