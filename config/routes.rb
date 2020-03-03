Rails.application.routes.draw do

  devise_for :users
  get 'pages/info'
  root to: redirect('/ideas')
  resources :ideas
  resources :comments, except: [:index, :new, :show]
end
