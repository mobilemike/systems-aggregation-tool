class AddDispositionColumnToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :disposition, :string
  end

  def self.down
    remove_column :computers, :disposition
  end
end
