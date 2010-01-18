require 'ipaddr'

class Computer < ActiveRecord::Base
  include AASM
  IP_PAD = 2147483648

  has_one :scom_computer, :dependent => :destroy
  has_one :akorri_server_storage, :dependent => :destroy
  has_one :epo_computer, :dependent => :destroy
  has_one :vmware_computer, :dependent => :destroy
  has_one :wsus_computer, :dependent => :destroy
  has_one :avamar_computer, :dependent => :destroy
  belongs_to :owner

  aasm_column :disposition
  aasm_initial_state :unknown
  aasm_state :unknown
  aasm_state :nonproduction
  aasm_state :production
  aasm_state :decomissioned
  aasm_state :archived
  aasm_state :remove
  
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
    healths = [0]
    healths << self.scom_computer.health if self.scom_computer
    healths << self.akorri_server_storage.health if self.akorri_server_storage
    healths << self.epo_computer.dat_health if self.epo_computer
    # healths << self.epo_computer.update_health if self.epo_computer
    healths << self.vmware_computer.cpu_health if self.vmware_computer
    healths << self.vmware_computer.memory_health if self.vmware_computer
    healths << self.avamar_computer.health if self.avamar_computer
    healths.max
  end
  
  def self.find_all_sorted_by_health(conditions=[])
    computers = self.find(:all,
                          :order => "computers.fqdn",
                          :conditions => conditions)
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
  
private
  
  def i_to_ip(int)
    IPAddr.new(int + IP_PAD, Socket::AF_INET).to_s
  end
  
  def ip_to_i(str)
    IPAddr.new(str).to_i - IP_PAD
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

