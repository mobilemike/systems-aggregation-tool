class CreateWsusComputers < ActiveRecord::Migration
  def self.up
    create_table :wsus_computers do |t|
      t.integer :computer_id
      t.string :fqdn
      t.datetime :last_sync
      t.datetime :last_status
      t.datetime :last_reboot
      t.string :ip_address
      t.integer :os_major
      t.integer :os_minor
      t.integer :os_build
      t.integer :os_sp
      t.string :make
      t.string :model
      t.string :bios_ver
      t.string :bios_name
      t.date :bios_date
      t.string :processor_type
      t.datetime :wsus_created_at
      t.string :client_ver
      t.integer :updates_unknown
      t.integer :updates_not_installed
      t.integer :updates_downloaded
      t.integer :updates_installed
      t.integer :updates_failed
      t.integer :updates_pending_reboot

      t.timestamps
    end
  end

  def self.down
    drop_table :wsus_computers
  end
end
