class AddComputerHashToWsusComputer < ActiveRecord::Migration
  def self.up
    add_column :wsus_computers, :computer_hash, :string
    add_column :wsus_computers, :updates_approved, :integer
  end

  def self.down
    remove_column :wsus_computers, :updates_approved
    remove_column :wsus_computers, :computer_hash
  end
end
