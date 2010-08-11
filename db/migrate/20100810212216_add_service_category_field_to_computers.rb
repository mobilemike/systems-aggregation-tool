class AddServiceCategoryFieldToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :service_category, :string, :default => "Unknown"
    
    Computer.update_all("service_category = 'Unknown'", "service_category IS NULL")
  end

  def self.down
    remove_column :computers, :service_category
  end
end
