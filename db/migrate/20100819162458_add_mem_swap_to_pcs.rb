class AddMemSwapToPcs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :mem_swap, :integer
  end

  def self.down
    remove_column :pcs, :mem_swap
  end
end
