Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :dogs
  resources :likes, only: [:create, :destroy]
  get 'page/:page', :to => 'dogs#paginated_index'
  root to: "dogs#paginated_index"
end
