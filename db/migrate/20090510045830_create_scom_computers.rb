class CreateScomComputers < ActiveRecord::Migration
  def self.up
    create_table :scom_computers do |t|
      t.string :bme
      t.string :fqdn
      t.string :adsite
      t.string :ip
      t.string :ou
      t.integer :health
      t.datetime :lastmodified

      t.timestamps
    end
  end

  def self.down
    drop_table :scom_computers
  end
end
