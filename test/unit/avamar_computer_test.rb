require 'test_helper'

class AvamarComputerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: avamar_computers
#
#  id                        :integer         not null, primary key
#  computer_id               :integer
#  fqdn                      :string(255)
#  avamar_domain             :string(255)
#  group_name                :string(255)
#  type                      :string(255)
#  dataset                   :string(255)
#  dataset_override          :boolean
#  retention_policy          :string(255)
#  effective_expiration      :date
#  retention_policy_override :boolean
#  schedule                  :string(255)
#  scheduled_start_at        :datetime
#  scheduled_end_at          :datetime
#  started_at                :datetime
#  completed_at              :datetime
#  num_of_files              :integer
#  bytes_scanned             :float
#  bytes_new                 :float
#  bytes_modified            :float
#  bytes_modified_sent       :float
#  bytes_modified_not_sent   :float
#  status_code               :integer
#  error_code                :integer
#  bytes_excluded            :float
#  bytes_skipped             :float
#  num_files_skipped         :float
#  client_os                 :string(255)
#  client_ver                :string(255)
#  bytes_overhead            :float
#  status_code_summary       :string(255)
#  error_code_summary        :string(255)
#  retention                 :string(255)
#  ip                        :string(255)
#  avamar_created_at         :date
#  enabled                   :boolean
#  restore_only              :boolean
#  modified_date             :date
#  created_at                :datetime
#  updated_at                :datetime
#

