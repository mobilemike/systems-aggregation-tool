class AddBmeToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :sc_bme, :string
  end

  def self.down
    remove_column :computers, :sc_bme
  end
end
