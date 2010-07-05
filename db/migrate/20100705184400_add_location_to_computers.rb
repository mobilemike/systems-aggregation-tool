class AddLocationToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :location, :string
  end

  def self.down
    remove_column :computers, :location
  end
end
