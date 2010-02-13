class AddInLdapToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :in_ldap, :boolean
  end

  def self.down
    remove_column :computers, :in_ldap
  end
end
