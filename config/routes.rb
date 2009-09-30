ActionController::Routing::Routes.draw do |map|
  map.resources :owners, :active_scaffold => true

  map.resources :computers, :active_scaffold => true, :member => { :health => :get, :chart => :get }
  map.resources :computers, :active_scaffold => true, :as => 'cmdb/computers', :member => { :health => :get, :chart => :get }
  
  map.root :controller => "computers"
end
