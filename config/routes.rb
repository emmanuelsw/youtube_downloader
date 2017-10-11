Rails.application.routes.draw do

  root 'downloads#index'
  post 'download', to: 'downloads#download'

  mount ActionCable.server => "/cable"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

end
