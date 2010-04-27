class ConvertProductionToTiers < ActiveRecord::Migration
  def self.up
  end

  def self.down
    Computer.update_all("disposition = 'production'", "disposition IN ('production_1', 'production_2', 'production_3')")
  end
end
