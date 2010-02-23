class AddActiveToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :active, :boolean
  end

  def self.down
    remove_column :issues, :active
  end
end
