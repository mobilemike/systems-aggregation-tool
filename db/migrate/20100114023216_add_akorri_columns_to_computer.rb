class AddAkorriColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :health_ak_cpu, :integer
    add_column :computers, :ak_cpu_last_modified, :datetime
    add_column :computers, :health_ak_storage, :integer
    add_column :computers, :ak_storage_last_modified, :datetime
    add_column :computers, :health_ak_mem, :integer
    add_column :computers, :ak_mem_last_modified, :datetime
  end

  def self.down
    remove_column :computers, :ak_mem_last_modified
    remove_column :computers, :health_ak_mem
    remove_column :computers, :ak_storage_last_modified
    remove_column :computers, :health_ak_storage
    remove_column :computers, :ak_cpu_last_modified
    remove_column :computers, :health_ak_cpu
  end
end
