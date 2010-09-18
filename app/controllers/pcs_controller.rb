class PcsController < ApplicationController
  before_filter :update_table_config
  
  ALL_COLUMNS = [:fqdn, :company, :last_logged_on, :ip, :make, :model, :us_outstanding, :ep_dat_outdated,
                 :in_epo, :in_ldap, :in_sccm, :in_wsus]
  
  active_scaffold :pc do |c|
    c.columns = ALL_COLUMNS
    

    c.columns[:ip].label                       = "IP"
    c.columns[:ip].sort_by :sql                => 'ip_int'
    c.columns[:last_logged_on].label           = "Last User"
    c.columns[:us_outstanding].description     = "Outstanding WSUS patches"
    c.columns[:us_outstanding].label           = "<img src=\"#{ActionController::Base.relative_url_root}/images/band_aid.png\" />"
    c.columns[:us_outstanding].sort_by :method => 'us_outstanding'
    c.columns[:ep_dat_outdated].label          = "DAT"
    c.columns[:fqdn].label                     = "Compuer"
    c.columns[:in_epo].label                   = "ePO"
    c.columns[:in_ldap].label                  = "AD"
    c.columns[:in_sccm].label                  = "SCCM"
    c.columns[:in_wsus].label                  = "WSUS"   


    c.actions.exclude :create, :delete, :nested
    
    c.update.link        = false

    c.list.per_page      = 20

    
    c.formats << :csv
  end
  
  def list_respond_to_csv
    @pcs = Pc.find_all_sorted_by_fqdn(conditions_for_collection)
  end
  
private

  def conditions_for_collection
    conditions = []
    conditions << @column_conditions
    Pc.merge_conditions(*conditions)
  end

  def update_table_config
    update_table_columns
    update_page_display
  end
  
  def update_table_columns
    base = ALL_COLUMNS
    
    col = nil
    con = nil
    sort = nil
    
    case params[:view]
    when "xxx"
    else
      col = base
    end
    
    active_scaffold_config.list.sorting = sort unless sort.nil?
    @column_conditions = con unless con.nil?
    unless col.nil?
      active_scaffold_config.list.columns = col
      active_scaffold_config.list.columns.set_columns(active_scaffold_config.columns)
    end
  end

  def update_page_display
    custom_label = "PCs"
    if params[:search]
      custom_label = "#{custom_label} (#{params[:search]})"
    end
    params[:page] ||= 1
    @page_title = active_scaffold_config.label = custom_label
  end
  
end