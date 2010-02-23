class Issue < ActiveRecord::Base
  
  belongs_to :computer
  
  def self.find_or_init(computer, category, source, text)
    self.find_or_initialize_by_active_and_computer_id_and_text(:active => true,
                                                               :computer_id => computer.id,
                                                               :category => category,
                                                               :source => source,
                                                               :text => text)
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

