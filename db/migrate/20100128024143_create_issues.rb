class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string :identifier, :source
      t.text :description
      t.integer :computer_id, :severity
      t.boolean :active
      
      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
