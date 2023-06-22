Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "dashboard", to: "pages#dashboard"
  resources :flats, except: [:index] do
    resources :invitations, only: [:new, :create] do
      member do
        patch :accept
        patch :decline
      end
    end
    resources :rooms, only: [:show, :new, :create, :edit, :update]
  end

  # avoiding double nesting
  resources :rooms, only: [:destroy] do
    resources :items, only: [:show, :new, :create, :edit, :update, :destroy]
  end
  resources :items, only: [] do
    resources :options, only: [:new, :create, :edit, :update, :destroy]
    member do
      get :quick_create_option
    end
  end
  resources :options, only: [] do
    resources :votes, only: [:create, :update]
  end
end
