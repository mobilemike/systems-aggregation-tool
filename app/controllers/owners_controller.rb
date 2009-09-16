class OwnersController < ApplicationController
  active_scaffold :owner do |c|
    c.columns = [:name, :initials]
  end
end
