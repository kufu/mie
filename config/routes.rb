# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/2024')

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/session', to: 'sessions#delete'

  resource :profile, only: %i[show update] do
    resources :friends, only: %i[new]
  end
  resources :profiles, only: %i[show update]

  scope '/:event_name', as: 'event' do
    get '/', to: 'static#top'
    get '/terms-of-service', to: 'static#terms_of_service'

    resources :schedules, only: %i[index show] do
      get '/dialog', to: 'schedules#dialog'
    end
    resources :plans, only: %i[show update create] do
      patch '/own', to: 'plans#editable'

      scope module: :plans do
        resource :ogp, only: %i[show]
      end
    end
  end

  resources :teams, except: :index do
    resources :members, only: %i[create update destroy]
  end

  resources :triggers, only: %i[show]

  namespace :admin do
    resources :triggers, only: %i[index show edit update]
  end

  get '*path', controller: 'application', action: 'not_found'
end
