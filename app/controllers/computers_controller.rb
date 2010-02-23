class ComputersController < ApplicationController
  before_filter :update_table_config
  
  ALL_COLUMNS = [:health, :fqdn, :owner, :status, :company, :description, :ip, :guest, :us_outstanding,
               :av_overview, :av_completed_at, :av_dataset, :av_retention, :av_schedule, :av_new, :av_scanned,
               :av_message, :health_av_last, :bios_ver, :bios_date, :make, :model, :serial_number,
               :hp_mgmt_ver, :ilo_ip, :host_computer, :vtools_ver, :mem_reservation, :mem_balloon,
               :cpu_reservation, :cpu_ready]
  
  active_scaffold :computer do |c|
    c.columns = ALL_COLUMNS
    
    c.columns[:av_completed_at].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/time.png\" />"
    c.columns[:av_dataset].label = 'Dataset'
    c.columns[:av_message].label = 'Avamar Status'
    c.columns[:av_message].sort_by :method => 'av_message || String.new'
    c.columns[:av_new].description = 'Deduped and compressed data from last backup'
    c.columns[:av_new].label = 'New'
    c.columns[:av_overview].description = "Avamar protection and health"
    c.columns[:av_overview].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/avamar.png\" />"
    c.columns[:av_overview].sort_by :sql => 'av_scanned'
    c.columns[:av_retention].label = 'Retention'
    c.columns[:av_scanned].description = 'Total protected data from last backup'
    c.columns[:av_scanned].label = 'Protected'
    c.columns[:av_schedule].label = 'Schedule'
    c.columns[:bios_date].label = "BIOS Date"
    c.columns[:bios_ver].label = "BIOS Ver"
    c.columns[:cpu_ready].label = "CPU Ready"
    c.columns[:cpu_reservation].label = 'CPU Reservation'
    c.columns[:fqdn].label = 'Computer'
    c.columns[:guest].description = "Virtual or Physical"
    c.columns[:guest].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/vmware.gif\" />"
    c.columns[:health].description = "Overall system health"
    c.columns[:health].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:health].sort_by :method => 'health'
    c.columns[:health_av_last].description = 'Avamar last backup health'
    c.columns[:health_av_last].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/cabbage_16.gif\" />"
    c.columns[:health_av_last].sort_by :method => 'health_av_last || 0'
    c.columns[:host_computer].label = 'Host'
    c.columns[:hp_mgmt_ver].label = "HP Agents"
    c.columns[:ilo_ip].label = "iLO IP"
    c.columns[:ilo_ip].sort_by :sql => 'ilo_ip_int'
    c.columns[:ip].label = "IP"
    c.columns[:ip].sort_by :sql => 'ip_int'
    c.columns[:mem_balloon].label = 'Memory Ballooned'
    c.columns[:mem_reservation].label = 'Memory Reservation'
    c.columns[:owner].description = "Assigned owner"   
    c.columns[:owner].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/owner.png\" />"
    c.columns[:serial_number].label = "Serial Number"
    c.columns[:status].description = "Production status"
    c.columns[:status].inplace_edit = true
    c.columns[:status].sort_by :sql => 'disposition'
    c.columns[:us_outstanding].description = "Outstanding WSUS patches"
    c.columns[:us_outstanding].label = "<img src=\"#{ActionController::Base.relative_url_root}/images/band_aid.png\" />"
    c.columns[:us_outstanding].sort_by :method => 'us_outstanding'
    c.columns[:vtools_ver].label = 'VM Tools'
    
    
    c.actions.exclude :create, :delete
    
    c.update.link = false
    
    c.show.link.label = "Detail"
    c.show.link.position = :after
    
    c.nested.add_link("Issues", [:issues])
    
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
    case params[:status]
    when nil
      conditions << ["computers.disposition NOT IN ('decommissioned', 'archived')"]
    when 'all'
    else
      conditions << ["computers.disposition = ?", params[:status]]
    end
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
      col = ALL_COLUMNS
    when 'avamar'
      col = [:health_av_last] + base + [:av_dataset, :av_retention, :av_schedule, :av_completed_at, :av_new, :av_scanned, :av_message]
      con = {:in_avamar => true}
      sort = [{:health_av_last => :desc}]
    when 'physical'
      col = base + [:bios_ver, :bios_date, :make, :model, :serial_number, :hp_mgmt_ver, :ilo_ip]
      con = {:guest => false}
    when 'virtual'
      col = base + [:host_computer, :vtools_ver, :mem_reservation, :mem_balloon, :cpu_reservation, :cpu_ready]
      con = {:guest => true}
    else
      col = [:health] + base + [:company, :description, :ip, :guest, :us_outstanding, :av_overview]
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