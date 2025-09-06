Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]

    # Two-factor configuration and challenge
    resource :two_factor_configuration, only: [:new, :create, :destroy]
    resource :two_factor_challenge,     only: [:new, :create]
    resources :backup_codes,            only: [:index, :create]

    # WebAuthn registration for hardware keys (authenticated user)
    namespace :webauthn do
      post "registration/options", to: "registrations#options"
      post "registration", to: "registrations#create"
    end
  end

  # WebAuthn authentication (passwordless)
  namespace :webauthn do
    post "authentication/options", to: "authentications#options"
    post "authentication", to: "authentications#create"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "profile", to: "home#index"
  # Defines the root path route ("/")
  root "home#welcome"
end
