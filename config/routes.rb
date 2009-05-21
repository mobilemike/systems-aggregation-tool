ActionController::Routing::Routes.draw do |map|
  map.resources :computers,
                :only => [:index, :show],
                :collection => { :computer_filter => [:get, :post] }
  
  map.root :controller => "computers"
end
