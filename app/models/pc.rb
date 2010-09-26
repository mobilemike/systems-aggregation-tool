require 'ipaddr'

class Pc < ActiveRecord::Base
    
#   before_save :compute_most_recent_update
    
    IP_PAD = 2147483648

    def self.find_all_sorted_by_fqdn(conditions=[])
      pc = self.find(:all,
                     :order => "pcs.fqdn",
                     :conditions => conditions)
    end

    def to_label
      self.name
    end

    def health_us_outstanding
      case self.us_outstanding
        when 0 then 0
        when 1..(1.0/0) then 3
      end
    end

    def us_outstanding
      if self.us_approved == nil or self.us_pending_reboot == nil or self.us_failed == nil
        -1
      else
        self.us_approved + self.us_pending_reboot + self.us_failed
      end
    end

    def health_ep_dat
      case ep_dat_outdated
        when -(1.0/0)..2 then 0
        when 3..4 then 2
        when 5..(1.0/0) then 3
      end
    end

    def name
      self.fqdn.split(".")[0].upcase if self.fqdn
    end

    def domain
      self.fqdn.split(".", 2)[1] if self.fqdn
    end

    def ip=(ip_str)
      self.ip_int = ip_to_i(ip_str)
    end

    def ip
      i_to_ip(self.ip_int)
    end

    def subnet_mask=(ip_str)
      self.subnet_mask_int = ip_to_i(ip_str)
    end

    def subnet_mask
      i_to_ip(self.subnet_mask_int)
    end

    def default_gateway=(ip_str)
      self.default_gateway_int = ip_to_i(ip_str)
    end

    def default_gateway
      i_to_ip(self.default_gateway_int)
    end

    def os_long
      [self.os_version, "SP #{self.os_sp}"].join(' ')
    end
    
    def compute_most_recent_update
      self.most_recent_update = [ep_last_update,us_last_sync,cm_last_heatbeat].max
    end
    
    def self.regenerate_health
      Pc.find_each do |pc|
        pc.compute_most_recent_update
        pc.save
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
#  cm_last_heatbeat    :datetime
#

