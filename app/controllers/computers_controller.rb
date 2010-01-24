class ComputersController < ApplicationController 
  before_filter :update_table_config
  
  active_scaffold :computer do |c|
    c.columns = [:health, :fqdn, :description, :owner, :status, :ip, :guest, :us_outstanding,
                 :av_overview, :av_dataset, :av_retention, :av_schedule, :av_new, :av_scanned,
                 :av_message, :health_av_last]
    
    c.columns[:fqdn].label = 'Computer'
    c.columns[:fqdn].description = 'Computer FQDN'
    c.columns[:health].sort_by :method => 'health'
    c.columns[:health].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:health].description = "Overall system health"
    c.columns[:us_outstanding].sort_by :method => 'us_outstanding'
    c.columns[:us_outstanding].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/band_aid.png\" />"
    c.columns[:us_outstanding].description = "Outstanding WSUS patches"
    c.columns[:status].sort_by :sql => 'disposition'
    c.columns[:status].description = "Current server status"
    c.columns[:status].inplace_edit = true
    c.columns[:owner].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/owner.png\" />"
    c.columns[:owner].description = "Assigned owner"   
    c.columns[:ip].sort_by :sql => 'ip_int'
    c.columns[:ip].label = "IP"
    c.columns[:ip].description = "Primary IP"
    c.columns[:guest].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    c.columns[:guest].description = "Virtual or Physical"
    c.columns[:av_overview].sort_by :sql
    c.columns[:av_overview].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/avamar.png\" />"
    c.columns[:av_overview].description = "Avamar protection and health"
    c.columns[:av_dataset].label = 'Dataset'
    c.columns[:av_retention].label = 'Retention'
    c.columns[:av_schedule].label = 'Schedule'
    c.columns[:av_new].label = 'New'
    c.columns[:av_new].description = 'Deduped and compressed data from last backup'
    c.columns[:av_scanned].label = 'Protected'
    c.columns[:av_scanned].description = 'Total protected data from last backup'
    c.columns[:av_message].label = 'Avamar Status'
    c.columns[:av_message].sort_by :method => 'av_message || String.new'
    c.columns[:health_av_last].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:health_av_last].sort_by :method => 'health_av_last || 0'
    c.columns[:health_av_last].description = 'Avamar last backup health'
    
    
    c.actions.exclude :create, :delete, :nested
    
    c.update.link = false
    
    c.show.link.label = "Detail"
    c.show.link.position = :after
    
    c.list.sorting = [{:health => :desc}]
    c.list.per_page = 20
    
    c.formats << :csv
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
    @computers = Computer.find_all_sorted_by_fqdn(conditions_for_collection)
  end
  
private

  def conditions_for_collection
    conditions = []
    conditions << @column_conditions
    conditions << ["computers.disposition = ?", params[:status]] if params[:status]
    conditions << ["computers.owner_id = ?", @owner.id] if params[:owner_initials]
    Computer.merge_conditions(*conditions)
  end

  def update_table_config
    update_table_columns
    update_page_display
  end
  
  def update_table_columns
    base = [:fqdn, :owner, :status]
    
    col = nil
    con = nil
    sort = nil
    
    case params[:view]
    when 'all'
      col = active_scaffold_config.list.columns
    when 'avamar'
      col = [:health_av_last] + base + [:av_dataset, :av_retention, :av_schedule, :av_new, :av_scanned, :av_message]
      con = ['computers.av_status IS NOT NULL']
      sort = [{:health_av_last => :desc}]
    else
      col = [:health] + base + [:description, :ip, :guest, :us_outstanding, :av_overview]
    end
    
    active_scaffold_config.list.sorting = sort unless sort.nil?
    @column_conditions = con unless con.nil?
    unless col.nil?
      active_scaffold_config.list.columns = col
      active_scaffold_config.list.columns.set_columns(active_scaffold_config.columns)
    end
    
  end

  def update_page_display
    custom_label = "Computers"
    if params[:status]
      custom_label = "#{custom_label} in #{params[:status].capitalize} Status"
    end
    if params[:owner_initials]
      @owner = Owner.find_by_initials(params[:owner_initials].upcase)
      custom_label = "#{@owner.first_name}'s #{custom_label}"
    end
    if params[:view]
      custom_label = "#{custom_label}, #{params[:view].capitalize} View"
    end
    if params[:search]
      custom_label = "#{custom_label} (#{params[:search]})"
    end
    params[:page] ||= 1
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