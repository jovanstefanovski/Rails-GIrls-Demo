Rails.application.routes.draw do

  get 'pages/info'
  root to: redirect('/ideas')
  resources :ideas
  resources :comments
end
