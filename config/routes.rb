require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :logs
  get "home/index"
  get "home/start_simulation" => "home#start_simulation", as: "start_simulation"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "/nodes/inactive_node/:id" => "nodes#inactive_node", as: "inactive_node"
  get "/nodes/kill_node/:id" => "nodes#kill_node", as: "kill_node"
  resources :nodes
  # Defines the root path route ("/")
  root "home#index"
end
