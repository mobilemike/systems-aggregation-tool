class AddDiskToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :total_disk, :integer
    add_column :computers, :free_disk, :integer
  end

  def self.down
    remove_column :computers, :free_disk
    remove_column :computers, :total_disk
  end
end
