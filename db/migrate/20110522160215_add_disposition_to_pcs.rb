class AddDispositionToPcs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :health, :string
  end

  def self.down
    remove_column :pcs, :health
  end
end
