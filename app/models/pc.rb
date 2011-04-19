require 'ipaddr'

class Pc < ActiveRecord::Base
    
  IP_PAD = 2147483648

  def self.find_all_sorted_by_fqdn(conditions=[])
    pc = find(:all,
              :order => "pcs.fqdn",
              :conditions => conditions)
  end
  
  def self.regenerate_health
    Pc.find_each do |pc|
      pc.compute_most_recent_update
      pc.save
    end
  end
  
  def compute_most_recent_update
    updates = []
    updates << ep_last_update if ep_last_update
    updates << us_last_sync if us_last_sync
    updates << cm_last_heartbeat if cm_last_heartbeat
    updates << ad_last_logon_timestamp if ad_last_logon_timestamp
    self.most_recent_update = updates.max unless updates.empty?
  end
  
  def default_gateway=(ip_str)
    default_gateway_int = ip_to_i(ip_str)
  end

  def default_gateway
    i_to_ip(default_gateway_int)
  end
  
  def domain
    fqdn.split(".", 2)[1] if fqdn
  end
  
  def ep_dat_description
    if in_epo?
      output = ep_dat_version.to_s
      
      if ep_dat_version == 0
        output += " (VS Not Installed)"
      else
        output += case ep_dat_outdated?
          when true then " (#{ep_dat_outdated} from current)"
          when false then " (Current)"
        end
      end
      
      return output
    end
  end

  def health_ep_dat
    case ep_dat_outdated
      when -(1.0/0)..2 then 0
      when 3..4 then 2
      when 5..(1.0/0) then 3
    end
  end

  def health_us_outstanding
    case us_outstanding
      when 0 then 0
      when 1..(1.0/0) then 3
    end
  end
  
  def ip=(ip_str)
    ip_int = ip_to_i(ip_str)
  end

  def ip
    i_to_ip(ip_int)
  end

  def name
    fqdn.split(".")[0].upcase if fqdn
  end

  def os_long
    # x64 = 'x64' if os_64?
    [os_version, os_edition, "SP #{self.os_sp}"].join(' ')
  end
  
  def sources_description
    sources = []
    
    sources << "ePO" if in_epo?
    sources << "AD" if in_ldap?
    sources << "SCCM" if in_sccm?
    sources << "WSUS" if in_wsus?
    
    if sources.empty?
      "None"
    else
      sources.to_sentence
    end
  end
  
  def subnet_mask=(ip_str)
    subnet_mask_int = ip_to_i(ip_str)
  end

  def subnet_mask
    i_to_ip(subnet_mask_int)
  end
  
  def to_label
    name
  end
  
  
  def us_outstanding
    if in_wsus?
      us_approved + us_pending_reboot + us_failed
    else
      0
    end
  end
  
  def us_outstanding_description
    if in_wsus?
      counts = []
      counts << "#{us_approved} Approved" if us_approved?
      counts << "#{us_pending_reboot} Pending Reboot" if us_pending_reboot?
      counts << "#{us_failed} Failed" if us_failed?
      output = us_outstanding.to_s
      output += " (#{counts.to_sentence})" unless counts.empty?
      
      return output
    end
  end
    
  private

  def i_to_ip(int)
    IPAddr.new(int + IP_PAD, Socket::AF_INET).to_s unless int.nil?
  end

  def ip_to_i(str)
    IPAddr.new(str).to_i - IP_PAD unless str.nil?
  end
end





# == Schema Information
#
# Table name: pcs
#
#  id                  :integer         not null, primary key
#  fqdn                :string(255)
#  cpu_speed           :integer
#  cpu_count           :integer
#  cpu_name            :string(255)
#  bios_date           :date
#  bios_name           :string(255)
#  bios_ver            :string(255)
#  boot_time           :datetime
#  ip_int              :integer
#  last_logged_on      :string(255)
#  mac                 :string(255)
#  make                :string(255)
#  mem_total           :integer
#  mem_used            :integer
#  model               :string(255)
#  os_sp               :string(255)
#  os_version          :string(255)
#  serial_number       :string(255)
#  subnet_mask_int     :integer
#  ep_last_update      :datetime
#  ep_dat_version      :integer
#  ep_dat_outdated     :integer
#  company             :string(255)     default("Unknown")
#  in_epo              :boolean
#  in_wsus             :boolean
#  in_ldap             :boolean
#  in_sccm             :boolean
#  us_group_name       :string(255)
#  disk_total          :integer
#  disk_free           :integer
#  us_last_sync        :datetime
#  us_unknown          :integer         default(0)
#  us_not_installed    :integer         default(0)
#  us_downloaded       :integer         default(0)
#  us_installed        :integer         default(0)
#  us_failed           :integer         default(0)
#  us_pending_reboot   :integer         default(0)
#  us_approved         :integer         default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  dhcp                :boolean
#  default_gateway_int :integer
#  time_zone_offset    :integer
#  install_date        :datetime
#  mem_swap            :integer
#  os_edition          :string(255)
#  cm_last_heartbeat   :datetime
#