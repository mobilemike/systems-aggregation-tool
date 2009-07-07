class ScomComputer < ActiveRecord::Base
  belongs_to :computer
  belongs_to :owner
end
