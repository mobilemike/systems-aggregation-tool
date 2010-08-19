class AddMemVmHostUsedToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :mem_vm_host_used, :integer
  end

  def self.down
    remove_column :computers, :mem_vm_host_used
  end
end
