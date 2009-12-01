class OwnersController < ApplicationController
  active_scaffold :owner do |c|
    c.columns = [:name, :initials]
    c.actions.exclude :create, :delete, :show
    c.action_links.add 'index', :controller => 'computers', :label => 'View all Computers', :page => true
    c.nested.add_link("Computers", [:computers])
  end
end
