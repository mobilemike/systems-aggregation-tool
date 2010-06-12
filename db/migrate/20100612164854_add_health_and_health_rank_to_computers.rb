class AddHealthAndHealthRankToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :health, :integer, :default => 0
    add_column :computers, :health_rank, :integer, :default => 0
  end

  def self.down
    remove_column :computers, :health_rank
    remove_column :computers, :health
  end
end
