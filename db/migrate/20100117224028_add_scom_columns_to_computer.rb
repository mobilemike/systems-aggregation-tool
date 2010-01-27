class AddScomColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :health_sc_state, :integer
    add_column :computers, :sc_cpu_perf_id, :integer
    add_column :computers, :sc_mem_perf_id, :integer
  end

  def self.down
    remove_column :computers, :sc_cpu_perf_id
    remove_column :computers, :sc_mem_perf_id
    remove_column :computers, :health_sc_state
  end
end
