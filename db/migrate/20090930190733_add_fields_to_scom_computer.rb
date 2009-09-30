class AddFieldsToScomComputer < ActiveRecord::Migration
  def self.up
    add_column :scom_computers, :virtual, :boolean
    add_column :scom_computers, :model, :string
    add_column :scom_computers, :serial_number, :string
    add_column :scom_computers, :bios_firmware, :string
    add_column :scom_computers, :management_version, :string
    add_column :scom_computers, :ilo_ip, :string
    add_column :scom_computers, :install_date, :datetime
    add_column :scom_computers, :cpus, :integer
    add_column :scom_computers, :domain, :string
    add_column :scom_computers, :scom_cpu_perf_id, :integer
    add_column :scom_computers, :scom_memory_perf_id, :integer
  end

  def self.down
    remove_column :scom_computers, :scom_memory_perf_id
    remove_column :scom_computers, :scom_cpu_perf_id
    remove_column :scom_computers, :domain
    remove_column :scom_computers, :cpus
    remove_column :scom_computers, :install_date
    remove_column :scom_computers, :ilo_ip
    remove_column :scom_computers, :management_version
    remove_column :scom_computers, :bios_firmware
    remove_column :scom_computers, :serial_number
    remove_column :scom_computers, :model
    remove_column :scom_computers, :virtual
  end
end
