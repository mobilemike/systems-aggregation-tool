class WsusComputer < ActiveRecord::Base
  belongs_to :computer
  
  def update_health
    case updates_outstanding
      when 0 then 1
      when 1..(1.0/0) then 3
    end
  end

  def updates_outstanding
    updates_approved + updates_pending_reboot + updates_failed
  end

  def to_label
    updates_outstanding
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

