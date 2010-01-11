class AkorriServerStorage < ActiveRecord::Base
  belongs_to :computer
end

# == Schema Information
#
# Table name: akorri_server_storages
#
#  id                :integer         not null, primary key
#  health            :integer
#  last_modified     :datetime
#  historical_health :string(255)
#  os_type           :integer
#  os_version        :string(255)
#  server_type       :integer
#  memory            :integer
#  swap              :integer
#  cpu_count         :integer
#  cpu_speed         :integer
#  fqdn              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  computer_id       :integer
#

