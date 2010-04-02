ActionController::Routing::Routes.draw do |map|
  map.resources :owners, :has_many => :computers, :active_scaffold => true
  map.resources :issues, :active_scaffold => true

  map.resources :computers,
                :active_scaffold => true,
                :member => { :health => :get, :chart => :get },
                :has_many => :issues
  map.owner 'computers/owner/:owner_initials', :controller => 'computers', :action => 'index'
  map.owner_status 'computers/owner/:owner_initials/status/:status', :controller => 'computers', :action => 'index'
  map.status 'computers/status/:status', :controller => 'computers', :action => 'index'
  map.resources :computers,
                :active_scaffold => true,
                :as => 'cmdb/computers',
                :member => { :health => :get, :chart => :get },
                :has_many => :issues
  
  map.root :controller => "computers"
end
