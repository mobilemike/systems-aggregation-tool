class RemoveOldTables < ActiveRecord::Migration
  def self.up
    drop_table :akorri_server_storages
    drop_table :avamar_computers
    drop_table :epo_computers
    drop_table :scom_computers
    drop_table :vmware_computers
    drop_table :wsus_computers
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
