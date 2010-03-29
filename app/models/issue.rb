class Issue < ActiveRecord::Base
  
  belongs_to :computer
  
  def self.find_or_init(computer, severity, source, identifier, description)
    self.find_or_initialize_by_active_and_computer_id_and_identifier(:active => true,
                                                                     :computer_id => computer.id,
                                                                     :severity => severity,
                                                                     :source => source,
                                                                     :identifier => identifier,
                                                                     :description => description)
  end
  
  def self.mark_old_closed
    self.update_all(["active = ?", false], ["active = ? AND updated_at < ?", true, Time.now.utc - 1.minute])
  end
  
end


# == Schema Information
#
# Table name: issues
#
#  id          :integer         not null, primary key
#  identifier  :string(255)
#  category    :string(255)
#  text        :string(255)
#  source      :string(255)
#  computer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean
#

