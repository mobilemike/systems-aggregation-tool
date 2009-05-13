class AddComputerIdToAkorriServerStorages < ActiveRecord::Migration
  def self.up
    add_column :akorri_server_storages, :computer_id, :integer
  end

  def self.down
    remove_column :akorri_server_storages, :computer_id
  end
end