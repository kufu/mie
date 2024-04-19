# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # OmniAuth test mode
    OmniAuth.config.test_mode = true

    # OmniAuth helper
    def omniauth_callback_uid(uid)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        {
          provider: 'github',
          uid:,
          info: {
            image: 'https://example.com/avatar'
          },
          extra: {
            raw_info: {
              login: 'test person'
            }
          }
        }
      )
    end
  end
end
