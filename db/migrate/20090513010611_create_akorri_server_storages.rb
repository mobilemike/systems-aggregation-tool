class CreateAkorriServerStorages < ActiveRecord::Migration
  def self.up
    create_table :akorri_server_storages do |t|
      t.integer :health
      t.datetime :last_modified
      t.string :historical_health
      t.integer :os_type
      t.string :os_version
      t.integer :server_type
      t.integer :memory
      t.integer :swap
      t.integer :cpu_count
      t.integer :cpu_speed
      t.string :fqdn

      t.timestamps
    end
  end

  def self.down
    drop_table :akorri_server_storages
  end
end
