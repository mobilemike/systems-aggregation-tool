class AddWideColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :bios_name, :string
    add_column :computers, :bios_ver, :string
    add_column :computers, :cpu_count, :integer
    add_column :computers, :cpu_name, :string
    add_column :computers, :cpu_ready, :float
    add_column :computers, :cpu_reservation, :integer
    add_column :computers, :cpu_speed, :integer
    add_column :computers, :guest, :boolean
    add_column :computers, :host, :boolean
    add_column :computers, :host_computer_id, :integer
    add_column :computers, :hp_mgmt_ver, :string
    add_column :computers, :ilo_ip, :integer, :limit => 8
    add_column :computers, :install_date, :datetime
    add_column :computers, :ip, :integer, :limit => 8
    add_column :computers, :last_logged_on, :string
    add_column :computers, :mac, :string
    add_column :computers, :mem_baloon, :integer
    add_column :computers, :mem_free, :integer
    add_column :computers, :mem_reservation, :integer
    add_column :computers, :mem_swap, :integer
    add_column :computers, :mem_total, :integer
    add_column :computers, :model, :string
    add_column :computers, :os_kernel_ver, :string
    add_column :computers, :os_type, :string
    add_column :computers, :os_vendor, :string
    add_column :computers, :os_version, :string
    add_column :computers, :serial_number, :string
    add_column :computers, :subnet_mask, :integer, :limit => 8
    add_column :computers, :vcpu_efficiency, :float
    add_column :computers, :vcpu_used, :float
  end

  def self.down
    remove_column :computers, :bios_name
    remove_column :computers, :bios_ver
    remove_column :computers, :cpu_count
    remove_column :computers, :cpu_name
    remove_column :computers, :cpu_ready
    remove_column :computers, :cpu_reservation
    remove_column :computers, :cpu_speed
    remove_column :computers, :guest
    remove_column :computers, :host
    remove_column :computers, :host_computer_id
    remove_column :computers, :hp_mgmt_ver
    remove_column :computers, :ilo_ip
    remove_column :computers, :install_date
    remove_column :computers, :ip
    remove_column :computers, :last_logged_on
    remove_column :computers, :mac
    remove_column :computers, :mem_baloon
    remove_column :computers, :mem_free
    remove_column :computers, :mem_reservation
    remove_column :computers, :mem_swap
    remove_column :computers, :mem_total
    remove_column :computers, :model
    remove_column :computers, :os_kernel_ver
    remove_column :computers, :os_type
    remove_column :computers, :os_vendor
    remove_column :computers, :os_version
    remove_column :computers, :serial_number
    remove_column :computers, :subnet_mask
    remove_column :computers, :vcpu_efficiency
    remove_column :computers, :vcpu_used
  end
end
