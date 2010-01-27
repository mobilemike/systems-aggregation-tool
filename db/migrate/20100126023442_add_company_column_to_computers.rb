class AddCompanyColumnToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :company, :string, :default => 'Unknown'
  end

  def self.down
    remove_column :computers, :company
  end
end
