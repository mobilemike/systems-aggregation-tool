class OwnersController < ApplicationController
  active_scaffold :owner do |c|
    c.columns = [:name, :initials]
    c.actions.exclude :create, :delete, :show 
    c.nested.add_link("Computers", [:computers])
  end
end
