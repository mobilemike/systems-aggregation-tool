class CreateEpoComputers < ActiveRecord::Migration
  def self.up
    create_table :epo_computers do |t|
      t.integer :computer_id
      t.string :fqdn
      t.integer :cpu_speed
      t.string :cpu_type
      t.integer :memory_free
      t.string :ip
      t.string :mac
      t.integer :cpu_count
      t.float :os_version
      t.string :os_type
      t.string :os_platform
      t.string :os_sp
      t.string :subnet
      t.string :subnet_mask
      t.integer :memory
      t.string :last_user
      t.datetime :last_update
      t.integer :dat_version
      t.integer :dat_health
      t.integer :update_health

      t.timestamps
    end
  end

  def self.down
    drop_table :epo_computers
  end
end
