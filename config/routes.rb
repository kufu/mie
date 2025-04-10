# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/2025')
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/session', to: 'sessions#delete'

  resource :profile, only: %i[show update] do
    resources :friends, only: %i[new]
  end
  resources :profiles, only: %i[show update]

  resources :teams do
    resources :members, only: %i[create update destroy]
  end

  resources :triggers, only: %i[show]

  resources :trophies, only: %i[show]

  namespace :admin do
    resources :triggers, only: %i[index show edit update]
    resources :trophies
  end

  scope '/:event_name', as: 'event' do
    get '/', to: 'schedules#index'
    get '/terms-of-service', to: 'static#terms_of_service'

    resources :plans, only: %i[show update create] do
      patch '/own', to: 'plans#editable'

      scope module: :plans do
        resource :ogp, only: %i[show]
      end

      resources :items, only: %i[create]
    end

    resources :items, only: %i[update destroy]
  end

  resolve('PlanSchedule') { %i[event item] }

  mount MissionControl::Jobs::Engine, at: "/admin/jobs"
  mount ActiveStorageDB::Engine => '/active_storage_db'
end
