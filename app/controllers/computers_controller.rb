class ComputersController < ApplicationController
  active_scaffold :computer do |c|
    c.columns = [ :health, :name, :domain, :owner, :ip, :wsus_computer]
    c.actions.exclude :create, :update
    
    c.columns[:health].sort_by :method => 'health'
    c.columns[:health].includes = [:wsus_computer, :akorri_server_storage, :scom_computer,
                                   :epo_computer, :vmware_computer]
    c.columns[:health].label = '<img src="images/cabbage_16.gif" />'
    c.columns[:name].sort_by :method => 'name'
    c.columns[:domain].sort_by :method => 'domain || String.new'
    c.columns[:ip].label = "IP"
    c.columns[:ip].sort_by :sql
    c.columns[:wsus_computer].sort_by :method => 'wsus_computer ? wsus_computer.updates_outstanding : 0'
    c.columns[:wsus_computer].label = "Updates"
    
    c.list.sorting = [{:health => :desc}]
    c.list.per_page = 20
  end
end