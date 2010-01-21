class ComputersController < ApplicationController 
  before_filter :update_table_config
  
  active_scaffold :computer do |c|
    c.columns = [ :health, :us_outstanding, :status, :name, :domain, :owner, :ip, :guest, :av_scanned]
    c.actions.exclude :create, :delete, :nested
    c.show.link.label = "Detail"
    c.update.link = false
    c.formats << :csv
   
    c.columns[:health].sort_by :method => 'health'
    c.columns[:health].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:health].description = "Overall system health"
    c.columns[:us_outstanding].sort_by :method => 'us_outstanding'
    c.columns[:us_outstanding].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/band_aid.png\" />"
    c.columns[:us_outstanding].description = "Outstanding WSUS patches"
    c.columns[:status].sort_by :sql => 'disposition'
    c.columns[:status].description = "Current server status"
    c.columns[:status].inplace_edit = true
    c.columns[:name].sort_by :method => 'name'
    c.columns[:name].description = "DNS name"
    c.columns[:owner].description = "Assigned owner's intials"   
    c.columns[:domain].sort_by :method => 'domain || String.new'
    c.columns[:domain].description = "DNS domain"
    c.columns[:ip].sort_by :sql => 'ip_int'
    c.columns[:ip].label = "IP"
    c.columns[:ip].description = "Primary IP"
    c.columns[:guest].sort_by :sql
    c.columns[:guest].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    c.columns[:guest].description = "Virtual or Physical"
    c.columns[:av_scanned].sort_by :sql
    c.columns[:av_scanned].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/avamar.png\" />"
    c.columns[:av_scanned].description = "Avamar Protection"
    c.list.sorting = [{:health => :desc}]
    c.list.per_page = 20
  end
  
  def health
    @computer = Computer.find(params[:id])
    render :partial => 'health'
  end
  
  def chart
    respond_to do |wants|
      wants.html {
        chart = chart_maker(:computer => Computer.find(params[:id]),
                             :type => params[:type])
        render :text => chart.render, :layout => false
      }
    end
  end
  
  def list_respond_to_csv
    @computers = Computer.find_all_sorted_by_health(conditions_for_collection)
  end
  
private

  def conditions_for_collection
    conditions = []
    conditions << ["computers.disposition = ?", params[:status]] if params[:status]
    conditions << ["computers.owner_id = ?", @owner.id] if params[:owner_initials]
    Computer.merge_conditions(*conditions)
  end

  def update_table_config
    custom_label = "Computers"
    excludes = []
    params[:search] = nil if params[:search] == ""
    if params[:status]
      custom_label = "#{custom_label} in #{params[:status].capitalize} Status"
      excludes << :status
    end
    if params[:owner_initials]
      @owner = Owner.find_by_initials(params[:owner_initials].upcase)
      custom_label = "#{@owner.first_name}'s #{custom_label}"
      excludes << :owner
    end
    if params[:search]
      custom_label = "#{custom_label} (#{params[:search]})"
    end
    params[:page] ||= 1
    active_scaffold_config.columns.exclude(*excludes)
    active_scaffold_config.label = custom_label
  end

  def chart_maker(*args)
    options = {
      :title => "Performance"
    }
    options.update(args.extract_options!)
    
    values = case options[:type]
    when "cpu" then options[:computer].scom_computer.scom_cpu_perf.data
    when "memory" then options[:computer].scom_computer.scom_cpu_perf.data
    end
      
    OFC::OpenFlashChart.new do |c|
      c.elements = []
      c.elements << OFC::ScatterLine.new(:dot_style => OFC::HollowDot.new(:dot_size => 3),
                                         :color => "#DB1750",
                                         :width => 3,
                                         :values => values)
      c.title = OFC::Title.new(:text => options[:title])
    end
  end
  
end