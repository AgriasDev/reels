Rails.application.routes.draw do
  root "game#index"
  resources :game do
    collection do
      post "Play"
    end
end
end
