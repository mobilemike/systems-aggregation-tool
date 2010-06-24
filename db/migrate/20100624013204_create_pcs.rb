class CreatePcs < ActiveRecord::Migration
  def self.up
    create_table :pcs do |t|
      t.string :fqdn
      t.integer :cpu_speed
      t.integer :cpu_count
      t.string :cpu_name
      t.date     :bios_date
      t.string   :bios_name
      t.string   :bios_ver
      t.datetime :boot_time
      t.integer :ip_int
      t.string :last_logged_on
      t.string :mac
      t.string :make
      t.integer :mem_total
      t.integer :mem_used
      t.string :model
      t.string :os_sp
      t.string :os_version
      t.string :serial_number
      t.integer :subnet_mask_int
      t.datetime :ep_last_update
      t.integer :ep_dat_version
      t.integer :ep_dat_outdated
      t.string :company,                  :default   => "Unknown"
      t.boolean :in_epo
      t.boolean :in_wsus
      t.boolean :in_ldap
      t.boolean :in_sccm
      t.string :us_group_name
      t.integer :disk_total
      t.integer :disk_free
      t.datetime :us_last_sync
      t.integer  :us_unknown,               :default => 0
      t.integer  :us_not_installed,         :default => 0
      t.integer  :us_downloaded,            :default => 0
      t.integer  :us_installed,             :default => 0
      t.integer  :us_failed,                :default => 0
      t.integer  :us_pending_reboot,        :default => 0
      t.integer  :us_approved,              :default => 0


      t.timestamps
    end
  end

  def self.down
    drop_table :pcs
  end
end
