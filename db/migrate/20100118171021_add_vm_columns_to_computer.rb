class AddVmColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :health_vm_vtools, :integer
  end

  def self.down
    remove_column :computers, :health_vm_vtools
  end
end
