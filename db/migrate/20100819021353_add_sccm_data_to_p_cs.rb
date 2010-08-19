class AddSccmDataToPCs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :dhcp, :boolean
    add_column :pcs, :default_gateway_int, :integer
    add_column :pcs, :time_zone_offset, :integer
    add_column :pcs, :install_date, :datetime
  end

  def self.down
    remove_column :pcs, :install_date
    remove_column :pcs, :time_zone_offset
    remove_column :pcs, :default_gateway_int
    remove_column :pcs, :dhcp
  end
end
