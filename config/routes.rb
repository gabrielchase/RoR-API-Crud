Rails.application.routes.draw do
  default_url_options :host => "https://gchase-rails-api.herokuapp.com"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :posts
  post 'sessions'   =>  'sessions#create'
  delete 'sessions/:id'   =>  'sessions#destroy'
end
