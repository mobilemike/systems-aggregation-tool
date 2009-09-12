class Computer < ActiveRecord::Base
  has_one :scom_computer
  has_one :akorri_server_storage
  has_one :epo_computer
  has_one :vmware_computer
  has_one :wsus_computer
  has_one :avamar_computer
  belongs_to :owner
  
  def health
    healths = [0]
    healths << self.scom_computer.health if self.scom_computer
    healths << 2 if self.akorri_server_storage.health >= 2 if self.akorri_server_storage
    healths << 2 if self.epo_computer.dat_health >= 2 if self.epo_computer
    healths << 2 if self.epo_computer.update_health >= 2 if self.epo_computer
    healths << self.vmware_computer.cpu_health if self.vmware_computer
    healths << self.vmware_computer.memory_health if self.vmware_computer
    healths << 2 if self.wsus_computer.update_health >= 2 if self.wsus_computer
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
  end
  
  def name
    self.fqdn.split(".")[0].upcase
  end
  
  def domain
    self.fqdn.split(".", 2)[1]
  end
  
end