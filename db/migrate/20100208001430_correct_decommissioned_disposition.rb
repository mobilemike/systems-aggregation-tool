class CorrectDecommissionedDisposition < ActiveRecord::Migration
  def self.up
    Computer.update_all("disposition = 'decommissioned'", "disposition = 'decomissioned'")
  end

  def self.down
    Computer.update_all("disposition = 'decomissioned'", "disposition = 'decommissioned'")
  end
end
