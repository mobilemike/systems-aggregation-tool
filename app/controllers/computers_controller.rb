class ComputersController < ApplicationController
  active_scaffold :computer do |c|
    c.columns = [ :health, :wsus_computer, :name, :domain, :owner, :virtual?, :ip]
    c.actions.exclude :create, :update, :delete
    
    c.columns[:health].sort_by :method => 'health'
    c.columns[:health].includes = [:wsus_computer, :akorri_server_storage, :scom_computer,
                                   :epo_computer, :vmware_computer]
    c.columns[:health].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:wsus_computer].sort_by :method => 'wsus_computer ? wsus_computer.updates_outstanding : 0.1'
    c.columns[:wsus_computer].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/band_aid.png\" />"
    c.columns[:name].sort_by :method => 'name'
    c.columns[:domain].sort_by :method => 'domain || String.new'
    c.columns[:virtual?].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    c.columns[:virtual?].sort_by :method => 'virtual? ? 1 : 0'
    c.columns[:ip].label = "IP"
    c.columns[:ip].sort_by :sql
    c.list.sorting = [{:health => :desc}]
    c.list.per_page = 20
  end
  
  def health
    @computer = Computer.find(params[:id])
    render :partial => 'health'
  end
end