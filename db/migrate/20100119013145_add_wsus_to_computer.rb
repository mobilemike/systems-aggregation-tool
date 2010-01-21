class AddWsusToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :us_last_sync, :datetime
    add_column :computers, :us_unknown, :integer, :default => 0
    add_column :computers, :us_not_installed, :integer, :default => 0
    add_column :computers, :us_downloaded, :integer, :default => 0
    add_column :computers, :us_installed, :integer, :default => 0
    add_column :computers, :us_failed, :integer, :default => 0
    add_column :computers, :us_pending_reboot, :integer, :default => 0
    add_column :computers, :us_approved, :integer, :default => 0
  end

  def self.down
    remove_column :computers, :us_installed
    remove_column :computers, :us_approved
    remove_column :computers, :us_pending_reboot
    remove_column :computers, :us_failed
    remove_column :computers, :us_downloaded
    remove_column :computers, :us_not_installed
    remove_column :computers, :us_unknown
    remove_column :computers, :us_last_sync
  end
end
