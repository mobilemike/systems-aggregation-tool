class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string :identifier, :category, :text
      t.integer :source, :computer_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
