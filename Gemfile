# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

gem 'rails', '~> 8.0'

gem 'propshaft'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.16'

gem 'rack-contrib', '~> 2.5.0'
gem 'rails-i18n', '~> 8.0.0'

gem 'jsbundling-rails', '~> 1.2'
gem 'stimulus-rails', '~> 1.3'
gem 'tailwindcss-rails', '~> 2.0'
gem 'turbo-rails', '~> 2.0'

gem 'omniauth-github', '~> 2.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

gem 'imgkit', '~> 1.6.3'
install_if -> { RUBY_PLATFORM =~ /darwin/ } do
  gem 'wkhtmltoimage-binary'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv', '~> 3.1'
  gem 'rubocop', '~> 1.18'
end

group :development do
  gem 'erb-formatter', '~> 0.4.3'
  gem 'listen', '~> 3.3'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rqrcode', '~> 2.2'

gem 'rexml', '~> 3.2'

gem 'solid_queue', '~> 0.3.0'

gem 'solid_cache', '~> 1.0'

gem 'activerecord-session_store', '~> 2.1'
