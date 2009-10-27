class AddColumnsToScomComputer < ActiveRecord::Migration
  def self.up
    add_column :scom_computers, :os_version_number, :string
    add_column :scom_computers, :memory, :integer
    add_column :scom_computers, :os, :string
    add_column :scom_computers, :os_sp, :integer
    add_column :scom_computers, :cores, :integer
    add_column :scom_computers, :server_2008_install_type, :string
  end

  def self.down
    remove_column :scom_computers, :server_2008_install_type
    remove_column :scom_computers, :cores
    remove_column :scom_computers, :os_sp
    remove_column :scom_computers, :os
    remove_column :scom_computers, :memory
    remove_column :scom_computers, :column_name
  end
end
