require 'ipaddr'

class Computer < ActiveRecord::Base
  include AASM
  IP_PAD = 2147483648

  belongs_to :owner
  belongs_to :host_computer, :class_name => "Computer"
  has_many :scom_cpu_perf, :class_name => "ScomPerformance", :foreign_key => "PerformanceSourceInternalId",
          :primary_key => "scom_cpu_perf_id"
  has_many :issues

  aasm_column :disposition
  aasm_initial_state :unknown
  aasm_state :production_1
  aasm_state :production_2
  aasm_state :production_3
  aasm_state :nonproduction
  aasm_state :decommissioned
  aasm_state :archived
  aasm_state :unknown
  aasm_state :remove
  
  def self.states_combined
    [["Production", "production"]] + self.aasm_states_for_select - [["Production 1", "production_1"],
                                                                    ["Production 2", "production_2"],
                                                                    ["Production 3", "production_3"]]
                                   
  end
  
  def production?
    production_3? || production_2? || production_1?
  end
  
  def online?
    production? || nonproduction?
  end
  
  def self.find_all_sorted_by_fqdn(conditions=[])
    computers = self.find(:all,
                          :order => "computers.fqdn",
                          :conditions => conditions)
  end
  
  def to_label
    self.name
  end
  
  def status
    self.disposition ? self.disposition.humanize : "-"
  end
  
  def status=(disposition)
    self.disposition = disposition.downcase.tr(" ", "_")
  end
  
  def self.states
    self.aasm_states.map {|s| s.display_name}
  end
  
  def health_av_last
    case self.av_status
      when /failed/i then 3
      when /successfully/i then 0
      else 2
    end
  end
  
  def av_message
    if health_av_last > 0
      self.av_error
    else
      self.av_status
    end
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
      when -(1.0/0)..0 then 0
      when 1 then 1
      when 2..3 then 2
      when 4..(1.0/0) then 3
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
  
  def ilo_ip=(ip_str)
    self.ilo_ip_int = ip_to_i(ip_str)
  end

  def ilo_ip
    i_to_ip(self.ilo_ip_int)
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
    [self.os_vendor, self.os_name, self.os_version, self.os_edition].join(' ')
  end
  
  def owner_initials
    self.owner.try(:initials)
  end
  
  def owner_initials=(initials)
    self.owner = Owner.find_by_initials(initials)
  end

  def is_windows?
    self.os_name == "Windows" ? true : false
  end
  
  def is_esx?
    self.os_name == "ESX" ? true : false
  end
  
  def self.regenerate_health
    Computer.all.each do |c|
      health = (c.issues.active.map {|i| i.severity}.max || 0)
      
      rank = health * 100
    
      rank += 1000 if (c.production? && health >= 4)
      
      rank += case c.aasm_current_state
        when :production_1 then  5
        when :production_2 then  4
        when :production_3 then  3
        when :nonproduction then 2
        when :unknown then       1
        else 0
      end
    
      c.health = health
      c.health_rank = rank
      c.save
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
# Table name: computers
#
#  id                       :integer         primary key
#  fqdn                     :string(255)
#  created_at               :timestamp
#  updated_at               :timestamp
#  owner_id                 :integer
#  disposition              :string(255)
#  bios_date                :date
#  bios_name                :string(255)
#  bios_ver                 :string(255)
#  boot_time                :timestamp
#  cpu_count                :integer
#  cpu_name                 :string(255)
#  cpu_ready                :float
#  cpu_reservation          :integer
#  cpu_speed                :integer
#  description              :text
#  guest                    :boolean         default(FALSE), not null
#  host                     :boolean         default(FALSE)
#  host_computer_id         :integer
#  hp_mgmt_ver              :string(255)
#  ilo_ip_int               :integer
#  install_date             :timestamp
#  ip_int                   :integer
#  last_logged_on           :string(255)
#  mac                      :string(255)
#  make                     :string(255)
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
#  power                    :boolean
#  serial_number            :string(255)
#  subnet_mask_int          :integer
#  vtools_ver               :integer
#  vcpu_efficiency          :float
#  vcpu_used                :float
#  health_ak_cpu            :integer
#  ak_cpu_last_modified     :timestamp
#  health_ak_storage        :integer
#  ak_storage_last_modified :timestamp
#  health_ak_mem            :integer
#  ak_mem_last_modified     :timestamp
#  health_sc_state          :integer
#  sc_cpu_perf_id           :integer
#  sc_mem_perf_id           :integer
#  ep_last_update           :timestamp
#  ep_dat_version           :integer
#  health_vm_vtools         :integer
#  av_dataset               :string(255)
#  av_retention             :string(255)
#  av_schedule              :string(255)
#  av_started_at            :timestamp
#  av_completed_at          :timestamp
#  av_file_count            :integer
#  av_scanned               :float
#  av_new                   :float
#  av_modified              :float
#  av_excluded              :float
#  av_skipped               :float
#  av_file_skipped_count    :integer
#  av_status                :string(255)
#  av_error                 :string(255)
#  us_last_sync             :timestamp
#  us_unknown               :integer         default(0)
#  us_not_installed         :integer         default(0)
#  us_downloaded            :integer         default(0)
#  us_installed             :integer         default(0)
#  us_failed                :integer         default(0)
#  us_pending_reboot        :integer         default(0)
#  us_approved              :integer         default(0)
#  ep_dat_outdated          :integer
#  company                  :string(255)     default("Unknown")
#  in_akorri                :boolean
#  in_avamar                :boolean
#  in_epo                   :boolean
#  in_scom                  :boolean
#  in_esx                   :boolean
#  in_wsus                  :boolean
#  in_ldap                  :boolean
#  us_group_name            :string(255)
#  total_disk               :integer
#  free_disk                :integer
#  sc_bme                   :string(255)
#  sc_uptime_percentage     :float
#  health                   :integer         default(0)
#  health_rank              :integer         default(0)
#  exempt_scom              :boolean         default(FALSE)
#  exempt_ldap              :boolean         default(FALSE)
#  exempt_avamar            :boolean         default(FALSE)
#  exempt_akorri            :boolean         default(FALSE)
#  exempt_epo               :boolean         default(FALSE)
#  exempt_wsus              :boolean         default(FALSE)
#  mem_vm_host_used         :integer
#  location                 :string(255)
#  in_sccm                  :boolean
#  exempt_sccm              :boolean
#  dhcp                     :boolean
#  default_gateway_int      :integer
#  time_zone_offset         :integer
#  service_category         :string(255)     default("Unknown")
#

