class AddComputerIdToScomComputers < ActiveRecord::Migration
  def self.up
    add_column :scom_computers, :computer_id, :integer
  end

  def self.down
    remove_column :scom_computers, :computer_id
  end
end
