class Computer < ActiveRecord::Base
  has_one :scom_computer
  has_one :akorri_server_storage
  
  def health
    healths = []
    healths << self.scom_computer.health if self.scom_computer
    healths << self.akorri_server_storage.health if self.akorri_server_storage
    healths.max
  end
  
  def self.find_all_sorted_by_health
    computers = self.find(:all,
              :include => [ :scom_computer, :akorri_server_storage ],
              :order => "scom_computers.health DESC, akorri_server_storages.health DESC, computers.fqdn"
              )
    computers.sort_by(&:health).reverse
  end
end