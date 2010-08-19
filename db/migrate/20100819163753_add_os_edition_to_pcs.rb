class AddOsEditionToPcs < ActiveRecord::Migration
  def self.up
    add_column :pcs, :os_edition, :string
  end

  def self.down
    remove_column :pcs, :os_edition
  end
end
