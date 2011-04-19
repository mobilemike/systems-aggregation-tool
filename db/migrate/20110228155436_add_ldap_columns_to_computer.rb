class AddLdapColumnsToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :ou, :string
    add_column :computers, :ad_last_logon_timestamp, :datetime
  end

  def self.down
    remove_column :computers, :ad_last_logon_timestamp
    remove_column :computers, :ou
  end
end
