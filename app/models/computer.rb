class Computer < ActiveRecord::Base
  include AASM

  has_one :scom_computer
  has_one :akorri_server_storage
  has_one :epo_computer
  has_one :vmware_computer
  has_one :wsus_computer
  has_one :avamar_computer
  belongs_to :owner

  aasm_column :disposition
  aasm_initial_state :unknown
  aasm_state :unknown
  aasm_state :lab
  aasm_state :preproduction
  aasm_state :production
  aasm_state :decomissioned
  aasm_state :archived
  
  def status
    self.disposition ? self.disposition.capitalize : "-"
  end
  
  def status=(disposition)
    self.disposition = disposition.downcase
  end
  
  def health
    healths = [0]
    healths << self.scom_computer.health if self.scom_computer
    healths << self.akorri_server_storage.health if self.akorri_server_storage
    healths << self.epo_computer.dat_health if self.epo_computer
    healths << self.epo_computer.update_health if self.epo_computer
    healths << self.vmware_computer.cpu_health if self.vmware_computer
    healths << self.vmware_computer.memory_health if self.vmware_computer
    healths << self.avamar_computer.health if self.avamar_computer
    healths.max
  end
  
  def self.find_all_sorted_by_health(computer_filter='')
    computers = self.find(:all,
              :include => [ :scom_computer, :akorri_server_storage, :epo_computer,
                            :vmware_computer, :wsus_computer, :avamar_computer, :owner ],
              :order => "scom_computers.health DESC,
                         akorri_server_storages.health DESC,
                         epo_computers.dat_health DESC,
                         epo_computers.update_health DESC,
                         vmware_computers.cpu_health DESC,
                         vmware_computers.memory_health DESC,
                         computers.fqdn",
              :conditions => ['computers.fqdn LIKE ?', '%' + computer_filter + '%' ]
              )
    computers.sort_by(&:health).reverse
  end
  
  def ip
    return self.epo_computer.ip if self.epo_computer
    return self.vmware_computer.ip if self.vmware_computer
    return self.scom_computer.ip.split(", ")[0] if self.scom_computer
    return "-"
  end
  
  def name
    self.fqdn.split(".")[0].upcase if self.fqdn
  end
  
  def domain
    self.fqdn.split(".", 2)[1] if self.fqdn
  end
  
  def virtual?
    virtual = false
    
    if self.wsus_computer
      if self.wsus_computer.model == "VMware Virtual Platform"
        virtual = true
      end
    end
    
    if self.vmware_computer
      unless self.vmware_computer.os_family == "esx" || self.vmware_computer.os_family == "embeddesEsx"
        virtual = true
      end
    end
    virtual
  end
  
  def os
    return self.epo_computer.ip if self.epo_computer
    return self.vmware_computer.ip if self.vmware_computer
    return self.scom_computer.ip.split(", ")[0] if self.scom_computer
    return "-"
  end
  
end



# == Schema Information
#
# Table name: computers
#
#  id               :integer         not null, primary key
#  fqdn             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  owner_id         :integer
#  disposition      :string(255)
#  ip               :integer(8)
#  mac              :string(255)
#  subnet_mask      :integer(8)
#  virtual          :boolean
#  serial_number    :string(255)
#  model            :string(255)
#  install_date     :datetime
#  cpu_count        :integer
#  cpu_speed        :integer
#  cpu_name         :string(255)
#  os_vendor        :string(255)
#  os_type          :string(255)
#  os_version       :string(255)
#  os_kernel_ver    :string(255)
#  mem_total        :integer
#  mem_free         :integer
#  mem_swap         :integer
#  last_logged_on   :string(255)
#  bios_name        :string(255)
#  bios_ver         :string(255)
#  ilo_ip           :integer(8)
#  hp_mgmt_ver      :string(255)
#  cpu_reaady       :float
#  host_computer_id :integer
#  mem_reservation  :integer
#  cpu_reservation  :integer
#  mem_baloon       :integer
#  vcpu_used        :float
#  vcpu_efficiency  :float
#

