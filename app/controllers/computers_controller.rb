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
    
    c.list.sorting = [{:health => :desc}, {:name => :asc}]
    c.list.per_page = 25
  end
  
  
  # def index
  #    @computers = Computer.find_all_sorted_by_health
  #  end
  #  
  #  def show
  #    @computer = Computer.find(params[:id])
  #  end
  #       
  #  def computer_filter
  #    @computers = Computer.find_all_sorted_by_health(params[:computer_filter])
  #    render :partial => "computers"
  #  end
end