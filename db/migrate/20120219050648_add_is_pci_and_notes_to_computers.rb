class AddIsPciAndNotesToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :is_pci, :boolean
    add_column :computers, :notes, :string
    add_column :pcs, :is_pci, :boolean
  end

  def self.down
    remove_column :pcs, :is_pci
    remove_column :computers, :notes
    remove_column :computers, :is_pci
  end
end
