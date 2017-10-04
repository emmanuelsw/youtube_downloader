Rails.application.routes.draw do
  root 'downloads#index'
  post 'download', to: 'downloads#download'
end
