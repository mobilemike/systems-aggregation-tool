class ModifySourceInIssue < ActiveRecord::Migration
  def self.up
    change_column :issues, :source, :string
  end

  def self.down
    change_column :issues, :source, :integer
  end
end
