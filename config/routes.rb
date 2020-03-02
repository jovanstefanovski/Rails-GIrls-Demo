Rails.application.routes.draw do

  get 'pages/info'
  root to: redirect('/ideas')
  resources :ideas
  resources :comments, except: [:index, :new, :show]
end
