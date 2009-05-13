class Computer < ActiveRecord::Base
  has_one :scom_computer
  has_one :akorri_server_storage
end