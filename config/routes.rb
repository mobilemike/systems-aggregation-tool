ActionController::Routing::Routes.draw do |map|
  map.resources :owners, :active_scaffold => true

  map.resources :computers, :active_scaffold => true, :member => { :health => :get }
  map.resources :computers, :as => 'cmdb/computers', :member => { :health => :get }
  
  map.root :controller => "computers"
end
