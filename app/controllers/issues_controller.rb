class IssuesController < ApplicationController
  active_scaffold :issues do |c|
    c.columns = [:severity, :source, :identifier, :description, :age]
    
    c.columns[:severity].description = "Overall system health"
    c.columns[:severity].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    
    c.actions.exclude :create, :delete, :show, :update
    
    
    
  end
end
