class IssuesController < ApplicationController
  active_scaffold :issues do |c|
    c.columns = [:severity, :source, :identifier, :description, :age]
    c.actions.exclude :create, :delete, :show, :update
  end
end
