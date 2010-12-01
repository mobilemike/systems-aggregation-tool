class AddMostRecentUpdateToPcs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :most_recent_update, :datetime
  end

  def self.down
    remove_column :pcs, :most_recent_update
  end
end