class AddSccmFieldsToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :in_sccm, :boolean
    add_column :computers, :exempt_sccm, :boolean
    add_column :computers, :dhcp, :boolean
    add_column :computers, :default_gateway_int, :integer
    add_column :computers, :time_zone_offset, :integer
  end

  def self.down
    remove_column :computers, :time_zone_offset
    remove_column :computers, :default_gateway_int
    remove_column :computers, :dhcp
    remove_column :computers, :exempt_sccm
    remove_column :computers, :in_sccm
  end
end
