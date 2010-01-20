class AddEpoColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :ep_last_update, :datetime
    add_column :computers, :ep_dat_version, :integer
  end

  def self.down
    remove_column :computers, :ep_dat_version
    remove_column :computers, :ep_last_update
  end
end
