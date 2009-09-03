class AddOwnerIdToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :owner_id, :integer
  end

  def self.down
    remove_column :computers, :owner_id
  end
end
