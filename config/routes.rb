ActionController::Routing::Routes.draw do |map|
  map.resources :owners

  map.resources :computers, :active_scaffold => true
  
  map.root :controller => "computers"
end
