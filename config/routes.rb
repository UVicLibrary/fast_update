Rails.application.routes.draw do

  get '/fast_update/replace_uri', to: 'fast_update/changes#index', as: :fast_update_replace_uri
  get '/fast_update/search_preview', to: 'fast_update/changes#search_preview', as: :fast_update_search_preview
  get '/fast_update/search_preview/page/:page', to: 'fast_update/changes#search_preview'

  namespace :fast_update do
    resources :changes, except: [:update, :edit]
  end

end