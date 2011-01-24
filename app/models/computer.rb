require 'ipaddr'

class Computer < ActiveRecord::Base
  include AASM
  IP_PAD = 2147483648

  belongs_to :owner
  belongs_to :host_computer, :class_name => "Computer"
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
  
  def self.find_all_sorted_by_fqdn(conditions=[])
    computers = find(:all,
                     :order => "computers.fqdn",
                     :conditions => conditions)
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

  def self.states
    aasm_states.map {|s| s.display_name}
  end
  
  def self.states_combined
    [["Production", "production"]] + aasm_states_for_select - [["Production 1", "production_1"],
                                                               ["Production 2", "production_2"],
                                                               ["Production 3", "production_3"]]                 
  end
  
  def av_message
    if health_av_last > 0
      av_error
    else
      av_status
    end
  end
  
  def default_gateway
    i_to_ip(default_gateway_int)
  end

  def default_gateway=(ip_str)
    self.default_gateway_int = ip_to_i(ip_str)
  end
  
  def domain
    fqdn.split(".", 2)[1] if fqdn
  end
  
  def hardware_type
    guest ? 'Virtual' : 'Physical'
  end
  
  def health_av_last
    case av_status
      when /failed/i then 3
      when /successfully/i then 0
      else 2
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
  
  def health_us_outstanding
    case us_outstanding
      when 0 then 0
      when 1..(1.0/0) then 3
    end
  end
  
  def ilo_ip
    i_to_ip(ilo_ip_int)
  end
  
  def ilo_ip=(ip_str)
    self.ilo_ip_int = ip_to_i(ip_str)
  end
  
  def ip
    i_to_ip(ip_int)
  end
  
  def ip=(ip_str)
    self.ip_int = ip_to_i(ip_str)
  end
  
  def is_windows?
    os_name == "Windows" ? true : false
  end
  
  def is_esx?
    os_name == "ESX" ? true : false
  end
  
  def name
    fqdn.split(".")[0].upcase if fqdn
  end
  
  def online?
    production? || nonproduction?
  end
  
  def os_long
    x64 = 'x64' if os_64?
    [os_vendor, os_name, os_version, os_edition, x64].join(' ')
  end
  
  def owner_initials
    owner.try(:initials)
  end
  
  def owner_initials=(initials)
    self.owner = Owner.find_by_initials(initials)
  end
  
  def production?
    production_3? || production_2? || production_1?
  end
  
  def status
    disposition ? disposition.humanize : "-"
  end
  
  def status=(disposition)
    self.disposition = disposition.downcase.tr(" ", "_")
  end
  
  def subnet_mask
    i_to_ip(subnet_mask_int)
  end
  
  def subnet_mask=(ip_str)
    self.subnet_mask_int = ip_to_i(ip_str)
  end
  
  def to_label
    name
  end
  
  def us_outstanding
    if in_wsus
      us_approved + us_pending_reboot + us_failed
    else
      -1
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
#
#  ak_cpu_last_modified     :timestamp
#  ak_mem_last_modified     :timestamp
#  ak_storage_last_modified :timestamp
#  av_completed_at          :timestamp
#  av_dataset               :string(255)
#  av_error                 :string(255)
#  av_excluded              :float
#  av_file_count            :integer
#  av_file_skipped_count    :integer
#  av_modified              :float
#  av_new                   :float
#  av_retention             :string(255)
#  av_scanned               :float
#  av_schedule              :string(255)
#  av_skipped               :float
#  av_started_at            :timestamp
#  av_status                :string(255)
#  bios_date                :date
#  bios_name                :string(255)
#  bios_ver                 :string(255)
#  boot_time                :timestamp
#  company                  :string(255)     default("Unknown")
#  cpu_count                :integer
#  cpu_name                 :string(255)
#  cpu_ready                :float
#  cpu_reservation          :integer
#  cpu_speed                :integer
#  created_at               :timestamp
#  default_gateway_int      :integer
#  description              :text
#  dhcp                     :boolean
#  disposition              :string(255)
#  ep_dat_outdated          :integer
#  ep_dat_version           :integer
#  ep_last_update           :timestamp
#  exempt_akorri            :boolean         default(FALSE)
#  exempt_avamar            :boolean         default(FALSE)
#  exempt_epo               :boolean         default(FALSE)
#  exempt_ldap              :boolean         default(FALSE)
#  exempt_sccm              :boolean
#  exempt_scom              :boolean         default(FALSE)
#  exempt_wsus              :boolean         default(FALSE)
#  fqdn                     :string(255)
#  free_disk                :integer
#  guest                    :boolean         default(FALSE), not null
#  health                   :integer         default(0)
#  health_ak_cpu            :integer
#  health_ak_mem            :integer
#  health_ak_storage        :integer
#  health_rank              :integer         default(0)
#  health_sc_state          :integer
#  health_vm_vtools         :integer
#  host                     :boolean         default(FALSE)
#  host_computer_id         :integer
#  hp_mgmt_ver              :string(255)
#  id                       :integer         primary key
#  ilo_ip_int               :integer
#  install_date             :timestamp
#  in_akorri                :boolean
#  in_avamar                :boolean
#  in_epo                   :boolean
#  in_esx                   :boolean
#  in_ldap                  :boolean
#  in_sccm                  :boolean
#  in_scom                  :boolean
#  in_wsus                  :boolean
#  ip_int                   :integer
#  last_logged_on           :string(255)
#  location                 :string(255)
#  mac                      :string(255)
#  make                     :string(255)
#  mem_balloon              :integer
#  mem_reservation          :integer
#  mem_swap                 :integer
#  mem_total                :integer
#  mem_used                 :integer
#  mem_vm_host_used         :integer
#  model                    :string(255)
#  os_64                    :boolean
#  os_edition               :string(255)
#  os_kernel_ver            :string(255)
#  os_name                  :string(255)
#  os_sp                    :integer
#  os_vendor                :string(255)
#  os_version               :string(255)
#  owner_id                 :integer
#  power                    :boolean
#  sc_bme                   :string(255)
#  sc_cpu_perf_id           :integer
#  sc_mem_perf_id           :integer
#  sc_uptime_percentage     :float
#  serial_number            :string(255)
#  service_category         :string(255)     default("Unknown")
#  subnet_mask_int          :integer
#  time_zone_offset         :integer
#  total_disk               :integer
#  updated_at               :timestamp
#  us_approved              :integer         default(0)
#  us_downloaded            :integer         default(0)
#  us_failed                :integer         default(0)
#  us_group_name            :string(255)
#  us_installed             :integer         default(0)
#  us_last_sync             :timestamp
#  us_not_installed         :integer         default(0)
#  us_pending_reboot        :integer         default(0)
#  us_unknown               :integer         default(0)
#  vcpu_efficiency          :float
#  vcpu_used                :float
#  vtools_ver               :integer


