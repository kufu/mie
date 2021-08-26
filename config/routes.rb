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
end
