class Computer < ActiveRecord::Base
  has_one :scom_computer
  has_one :akorri_server_storage
  has_one :epo_computer
  
  def health
    healths = [0]
    healths << self.scom_computer.health if self.scom_computer
    healths << self.akorri_server_storage.health if self.akorri_server_storage
    healths << self.epo_computer.dat_health if self.epo_computer
    healths << self.epo_computer.update_health if self.epo_computer
    healths.max
  end
  
  def self.find_all_sorted_by_health
    computers = self.find(:all,
              :include => [ :scom_computer, :akorri_server_storage, :epo_computer ],
              :order => "scom_computers.health DESC,
                         akorri_server_storages.health DESC,
                         epo_computers.dat_health DESC,
                         epo_computers.update_health DESC, 
                         computers.fqdn"
              )
    computers.sort_by(&:health).reverse
  end
end