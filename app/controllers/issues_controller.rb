class IssuesController < ApplicationController
  active_scaffold :issues do |c|
    c.columns = [:category, :source, :text]
  end
end
