class RenameScomComputersColumns < ActiveRecord::Migration
  def self.up
    rename_column :scom_computers, :adsite, :ad_site
    rename_column :scom_computers, :lastmodified, :last_modified
  end

  def self.down
    rename_column :scom_computers, :last_modified, :lastmodified
    rename_column :scom_computers, :ad_site, :adsite
  end
end
