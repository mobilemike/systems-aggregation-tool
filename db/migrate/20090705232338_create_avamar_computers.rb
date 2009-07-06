class CreateAvamarComputers < ActiveRecord::Migration
  def self.up
    create_table :avamar_computers do |t|
      t.integer :computer_id
      t.string :fqdn
      t.string :avamar_domain
      t.string :group_name
      t.string :type
      t.string :dataset
      t.boolean :dataset_override
      t.string :retention_policy
      t.date :effective_expiration
      t.boolean :retention_policy_override
      t.string :schedule
      t.datetime :scheduled_start_at
      t.datetime :scheduled_end_at
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :num_of_files
      t.float :bytes_scanned
      t.float :bytes_new
      t.float :bytes_modified
      t.float :bytes_modified_sent
      t.float :bytes_modified_not_sent
      t.integer :status_code
      t.integer :error_code
      t.float :bytes_excluded
      t.float :bytes_skipped
      t.float :num_files_skipped
      t.string :client_os
      t.string :client_ver
      t.float :bytes_overhead
      t.string :status_code_summary
      t.string :error_code_summary
      t.string :retention
      t.string :ip
      t.date :avamar_created_at
      t.boolean :enabled
      t.boolean :restore_only
      t.date :modified_date

      t.timestamps
    end
  end

  def self.down
    drop_table :avamar_computers
  end
end
