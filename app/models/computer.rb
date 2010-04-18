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
  aasm_state :unknown
  aasm_state :nonproduction
  aasm_state :production
  aasm_state :decommissioned
  aasm_state :archived
  aasm_state :remove
  
  def self.find_all_sorted_by_fqdn(conditions=[])
    computers = self.find(:all,
                          :order => "computers.fqdn",
                          :conditions => conditions)
  end
  
  def to_label
    self.name
  end
  
  def status
    self.disposition ? self.disposition.capitalize : "-"
  end
  
  def status=(disposition)
    self.disposition = disposition.downcase
  end
  
  def self.states
    self.aasm_states.map {|s| s.display_name}
  end

  def health
    self.issues.active.map {|i| i.severity + 1}.max || 0
  end
  
  def health_rank
    self.issues.active.map {|i| i.severity}.inject(0) {|sum, n| sum + n}
  end
  
  def health_av_last
    case self.av_status
      when /failed/i then 3
      when /successfully/i then 0
      else 2
    end
  end
  
  def av_message
    if health_av_last > 1
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
      when 1..2 then 1
      when 3..5 then 2
      when 6..(1.0/0) then 3
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
  
  def os_long
    [self.os_vendor, self.os_name, self.os_version, self.os_edition].join(' ')
  end

  def is_windows?
    self.os_name == "Windows" ? true : false
  end
  
  def is_esx?
    self.os_name == "ESX" ? true : false
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
#  id                       :integer         not null, primary key
#  fqdn                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  owner_id                 :integer
#  disposition              :string(255)
#  bios_date                :date
#  bios_name                :string(255)
#  bios_ver                 :string(255)
#  boot_time                :datetime
#  cpu_count                :integer
#  cpu_name                 :string(255)
#  cpu_ready                :float
#  cpu_reservation          :integer
#  cpu_speed                :integer
#  description              :text
#  guest                    :boolean         default(FALSE)
#  host                     :boolean         default(FALSE)
#  host_computer_id         :integer
#  hp_mgmt_ver              :string(255)
#  ilo_ip_int               :integer
#  install_date             :datetime
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
#  ak_cpu_last_modified     :datetime
#  health_ak_storage        :integer
#  ak_storage_last_modified :datetime
#  health_ak_mem            :integer
#  ak_mem_last_modified     :datetime
#  health_sc_state          :integer
#  sc_cpu_perf_id           :integer
#  sc_mem_perf_id           :integer
#  ep_last_update           :datetime
#  ep_dat_version           :integer
#  health_vm_vtools         :integer
#  av_dataset               :string(255)
#  av_retention             :string(255)
#  av_schedule              :string(255)
#  av_started_at            :datetime
#  av_completed_at          :datetime
#  av_file_count            :integer
#  av_scanned               :float
#  av_new                   :float
#  av_modified              :float
#  av_excluded              :float
#  av_skipped               :float
#  av_file_skipped_count    :integer
#  av_status                :string(255)
#  av_error                 :string(255)
#  us_last_sync             :datetime
#  us_unknown               :integer         default(0)
#  us_not_installed         :integer         default(0)
#  us_downloaded            :integer         default(0)
#  us_installed             :integer         default(0)
#  us_failed                :integer         default(0)
#  us_pending_reboot        :integer         default(0)
#  us_approved              :integer         default(0)
#  ep_dat_outdated          :integer
#  company                  :string(255)     default("Unknown")
#  sc_bme                   :string(255)
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
#

