Rails.application.routes.draw do
  # root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'users#index', as: 'users'
  get '/new', to: 'users#new', as: 'new_user'
  post '/', to: 'users#create'
  get '/:twitterhandle', to: 'users#show', as: 'user'
  get '/:twitterhandle/edit', to: 'users#edit', as: 'edit_user'
  patch '/:id', to: 'users#update'
  delete '/:id', to: 'users#destroy'

  get '/:twitterhandle/complete', to: 'users#complete', as: 'complete_user'

  # Twitter Webhook routes for Account Activity API
  get '/webhook/twitter', to: 'webhook#confirm_crc'
  post '/webhook/twitter', to: 'webhook#filter_events'
end
