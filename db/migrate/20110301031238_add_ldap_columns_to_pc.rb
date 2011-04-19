class AddLdapColumnsToPc < ActiveRecord::Migration
  def self.up
    add_column :pcs, :ou, :string
    add_column :pcs, :ad_last_logon_timestamp, :datetime
  end

  def self.down
    remove_column :pcs, :ad_last_logon_timestamp
    remove_column :pcs, :ou
  end
end
