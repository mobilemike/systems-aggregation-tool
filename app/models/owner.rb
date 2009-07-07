class Owner < ActiveRecord::Base
  has_one :scom_computer
end
