ActionController::Routing::Routes.draw do |map|
  map.root :action => 'welcome', :controller => 'stocks'
  map.connect 'portfolio/:portfolio_id/:action/:id', :controller => 'stocks'
  map.connect 'portfolio/:portfolio_id/:action/', :controller => 'stocks'
  map.connect ':controller/:action/'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
