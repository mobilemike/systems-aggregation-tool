class MakeGuestDefaultToFalse < ActiveRecord::Migration
  def self.up
    say_with_time "Setting all guest columns to false if nil..." do
      Computer.all.each do |p|
        p.update_attribute :guest, false unless p.guest?
      end
    end
    
    change_column :computers, :guest, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :computers, :guest, :boolean
  end
end
