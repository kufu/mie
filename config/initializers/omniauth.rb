# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch('GITHUB_KEY', nil), ENV.fetch('GITHUB_SECRET', nil), scope: 'read:user'
end
