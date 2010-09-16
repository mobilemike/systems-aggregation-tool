ActionController::Routing::Routes.draw do |map|
  map.resources :pcs, :active_scaffold => true

  map.resources :owners, :has_many => :computers, :active_scaffold => true
  map.resources :issues, :active_scaffold => true

  map.resources :servers,
                :active_scaffold => true,
                :member => { :health => :get, :chart => :get },
                :has_many => :issues
  map.owner 'servers/owner/:owner_initials', :controller => 'servers', :action => 'index'
  map.owner_status 'servers/owner/:owner_initials/status/:status', :controller => 'servers', :action => 'index'
  map.status 'servers/status/:status', :controller => 'servers', :action => 'index'
  
  map.root :controller => "servers"
end
