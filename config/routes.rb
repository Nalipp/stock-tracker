Rails.application.routes.draw do
  devise_for :users
  get 'welcome_index', to: 'welcome#index'
  get 'search_stocks', to: 'stocks#search'
  root 'users#my_portfolio'
end
