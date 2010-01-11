class EpoComputer < ActiveRecord::Base
  belongs_to :computer
end

# == Schema Information
#
# Table name: epo_computers
#
#  id            :integer         not null, primary key
#  computer_id   :integer
#  fqdn          :string(255)
#  cpu_speed     :integer
#  cpu_type      :string(255)
#  memory_free   :integer
#  ip            :string(255)
#  mac           :string(255)
#  cpu_count     :integer
#  os_version    :float
#  os_type       :string(255)
#  os_platform   :string(255)
#  os_sp         :string(255)
#  subnet        :string(255)
#  subnet_mask   :string(255)
#  memory        :integer
#  last_user     :string(255)
#  last_update   :datetime
#  dat_version   :integer
#  dat_health    :integer
#  update_health :integer
#  created_at    :datetime
#  updated_at    :datetime
#

