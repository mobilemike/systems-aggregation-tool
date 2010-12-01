class AddIndexToPcs < ActiveRecord::Migration
  def self.up
    add_index :pcs, :fqdn
  end

  def self.down
    remove_index :pcs, :fqdn
  end
end
