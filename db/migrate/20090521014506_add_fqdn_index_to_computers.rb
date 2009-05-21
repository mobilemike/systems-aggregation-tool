class AddFqdnIndexToComputers < ActiveRecord::Migration
  def self.up
    add_index :computers, :fqdn
  end

  def self.down
    remove_index :computers, :fqdn
  end
end
