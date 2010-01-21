class AddEpdatBehindColumnToCompter < ActiveRecord::Migration
  def self.up
    add_column :computers, :ep_dat_outdated, :integer
  end

  def self.down
    remove_column :computers, :ep_dat_outdated
  end
end
