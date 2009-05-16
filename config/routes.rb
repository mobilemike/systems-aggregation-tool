ActionController::Routing::Routes.draw do |map|
  map.resources :computers
  map.root :controller => "computers"

end
