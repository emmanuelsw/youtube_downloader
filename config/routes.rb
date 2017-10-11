Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root 'downloads#index'
  post 'download', to: 'downloads#download'
end
