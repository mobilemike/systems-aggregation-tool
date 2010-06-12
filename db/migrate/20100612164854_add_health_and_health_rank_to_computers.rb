class AddHealthAndHealthRankToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :health, :integer
    add_column :computers, :health_rank, :integer
  end

  def self.down
    remove_column :computers, :health_rank
    remove_column :computers, :health
  end
end
