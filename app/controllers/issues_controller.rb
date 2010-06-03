class IssuesController < ApplicationController
  active_scaffold :issues do |c|
    c.columns = [:severity, :source, :identifier, :description, :age]
    
    c.columns[:severity].description = HEALTH_DESCRIPTION
    c.columns[:severity].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    
    c.actions.exclude :create, :delete, :show, :update
    
    c.list.sorting = [{:severity => :desc}]
    
  end
end
