class IssuesController < ApplicationController
  active_scaffold :issues do |c|
    c.columns = [:category, :source, :text]
    c.actions.exclude :create, :delete, :show, :update
  end
end
