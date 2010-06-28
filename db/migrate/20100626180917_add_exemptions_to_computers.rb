class AddExemptionsToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :exempt_scom, :boolean, :default => false
    add_column :computers, :exempt_ldap, :boolean, :default => false
    add_column :computers, :exempt_avamar, :boolean, :default => false
    add_column :computers, :exempt_akorri, :boolean, :default => false
    add_column :computers, :exempt_epo, :boolean, :default => false
    add_column :computers, :exempt_wsus, :boolean, :default => false
  end

  def self.down
    remove_column :computers, :exempt_wsus
    remove_column :computers, :exempt_epo
    remove_column :computers, :exempt_akorri
    remove_column :computers, :exempt_avamar
    remove_column :computers, :exempt_ldap
    remove_column :computers, :exempt_scom
  end
end
