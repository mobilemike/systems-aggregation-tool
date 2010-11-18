class AddCmLastHeartbeatToPcs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :cm_last_heartbeat, :datetime
  end

  def self.down
    remove_column :pcs, :cm_last_heartbeat
  end
end
