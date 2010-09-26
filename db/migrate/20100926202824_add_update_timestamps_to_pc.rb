class AddUpdateTimestampsToPc < ActiveRecord::Migration
  def self.up
    add_column :pcs, :cm_last_heatbeat, :datetime
  end

  def self.down
    remove_column :pcs, :cm_last_heatbeat
  end
end