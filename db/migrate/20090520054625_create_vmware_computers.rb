class CreateVmwareComputers < ActiveRecord::Migration
  def self.up
    create_table :vmware_computers do |t|
      t.integer :computer_id
      t.string :name
      t.integer :power
      t.string :os
      t.string :os_family
      t.integer :memory
      t.integer :cpu_count
      t.integer :nic_count
      t.string :fqdn
      t.string :ip
      t.integer :tools_status
      t.integer :tools_version
      t.datetime :boot_time
      t.integer :memory_overhead
      t.string :description
      t.integer :host_computer_id
      t.integer :type
      t.integer :vmotion
      t.string :os_version
      t.integer :os_build
      t.string :vendor
      t.string :model
      t.string :cpu_type
      t.integer :cpu_speed
      t.integer :hba_count
      t.integer :maintenance_mode
      t.integer :cpu_health
      t.integer :memory_health

      t.timestamps
    end
  end

  def self.down
    drop_table :vmware_computers
  end
end
