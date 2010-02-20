class AddGroupNameToWsusSync < ActiveRecord::Migration
  def self.up
    add_column :computers, :us_group_name, :string
  end

  def self.down
    remove_column :computers, :us_group_name
  end
end
