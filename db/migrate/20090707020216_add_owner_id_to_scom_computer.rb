class AddOwnerIdToScomComputer < ActiveRecord::Migration
  def self.up
    add_column :scom_computers, :owner_id, :string
  end

  def self.down
    remove_column :scom_computers, :owner_id
  end
end
