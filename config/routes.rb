# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/2023')

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/session', to: 'sessions#delete'

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

    resource :profile, only: %i[show update]
  end

  get '*path', controller: 'application', action: 'not_found'
end
