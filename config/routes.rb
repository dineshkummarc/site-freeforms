ActionController::Routing::Routes.draw do |map|
  
  map.resources :forms, :member => [ :code, :clone, :messages, :unread ], :collection => [ :preview ]  
  map.resources :messages, :collection => [ :unread, :today ]
    
  map.resource :account
  map.resource :session
  
  map.resources :account_passwords
  map.resources :account_activations  
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.post_message '/post/:form_id', :controller => 'root', :action => 'post'
  map.message_status '/status/:token', :controller => 'root', :action => 'status'
    
  map.root :controller => 'root', :action => 'index'
  map.start '/start', :controller => 'root', :action => 'start'
  map.about '/about', :controller => 'root', :action => 'about'
  
  map.connect ':controller.:format'
  map.connect ':controller/:action/:id.:format'
end
