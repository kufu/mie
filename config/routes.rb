# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'static#index'

  scope '2021' do
    get '/', to: 'static#top'

    resources :schedules, only: %i[index show]
    resources :plans, only: %i[show update create] do
      patch '/own', to: 'plans#editable'

      scope module: :plans do
        resource :ogp, only: %i[show]
      end
    end
  end

  scope '2022' do
    scope 'api' do
      resources :schedules, only: %i[index]
      resources :plans, only: %i[show update create] do
        patch '/challange', to: 'plans#editable'

        scope module: :plans do
          get :ogp, to: 'ogps#show'
        end
      end
    end

    get '*path', to: 'static#frontend'
  end

  get '*path', controller: 'application', action: 'not_found'
end
