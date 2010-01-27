class AddAvamarToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :av_dataset, :string
    add_column :computers, :av_retention, :string
    add_column :computers, :av_schedule, :string
    add_column :computers, :av_started_at, :datetime
    add_column :computers, :av_completed_at, :datetime
    add_column :computers, :av_file_count, :integer
    add_column :computers, :av_scanned, :float
    add_column :computers, :av_new, :float
    add_column :computers, :av_modified, :float
    add_column :computers, :av_excluded, :float
    add_column :computers, :av_skipped, :float
    add_column :computers, :av_file_skipped_count, :integer
    add_column :computers, :av_status, :string
    add_column :computers, :av_error, :string
  end

  def self.down
    remove_column :computers, :av_dataset
    remove_column :computers, :av_retention
    remove_column :computers, :av_schedule
    remove_column :computers, :av_started_at
    remove_column :computers, :av_completed_at
    remove_column :computers, :av_file_count
    remove_column :computers, :av_scanned
    remove_column :computers, :av_new
    remove_column :computers, :av_modified
    remove_column :computers, :av_excluded
    remove_column :computers, :av_skipped
    remove_column :computers, :av_file_skipped_count
    remove_column :computers, :av_status
    remove_column :computers, :av_error
  end
end
