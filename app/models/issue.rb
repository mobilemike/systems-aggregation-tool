class Issue < ActiveRecord::Base
  
  belongs_to :computer
  
  named_scope :active, :conditions => {:active => true}
  named_scope :scom_only, :conditions => {:source => 'SCOM'}
  named_scope :without_scom, :conditions => "source != 'SCOM'"
  
  
  def self.find_or_init(computer, severity, source, identifier, description)
    self.find_or_initialize_by_active_and_computer_id_and_identifier_and_severity(:active => true,
                                                                                  :computer_id => computer.id,
                                                                                  :severity => severity,
                                                                                  :source => source,
                                                                                  :identifier => identifier,
                                                                                  :description => description)
  end
  
  def self.mark_old_closed
    self.update_all(["active = ?", false], ["active = ? AND updated_at < ?", true, Time.now.utc - 32.minutes])
  end
  
end



# == Schema Information
#
# Table name: issues
#
#  id          :integer         not null, primary key
#  identifier  :string(255)
#  source      :string(255)
#  description :text
#  computer_id :integer
#  severity    :integer
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

