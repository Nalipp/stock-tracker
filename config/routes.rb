Rails.application.routes.draw do
  devise_for :users
  get 'welcome_index', to: 'welcome#index'
  root 'users#my_portfolio'
end
