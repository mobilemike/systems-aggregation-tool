class AddScomUptimeColumnToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :sc_uptime_percentage, :decimal
  end

  def self.down
    remove_column :computers, :sc_uptime_percentage
  end
end
