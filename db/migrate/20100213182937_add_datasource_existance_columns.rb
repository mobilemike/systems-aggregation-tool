class AddDatasourceExistanceColumns < ActiveRecord::Migration
  def self.up
    add_column :computers, :in_akorri, :boolean
    add_column :computers, :in_avamar, :boolean
    add_column :computers, :in_epo, :boolean
    add_column :computers, :in_scom, :boolean
    add_column :computers, :in_esx, :boolean
    add_column :computers, :in_wsus, :boolean
  end

  def self.down
    remove_column :computers, :in_wsus
    remove_column :computers, :in_esx
    remove_column :computers, :in_scom
    remove_column :computers, :in_epo
    remove_column :computers, :in_avamar
    remove_column :computers, :in_akorri
  end
end
