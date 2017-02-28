Rails.application.routes.draw do

  resources :users, only: :create do
    collection do
      post :confirm
    end
  end
end
