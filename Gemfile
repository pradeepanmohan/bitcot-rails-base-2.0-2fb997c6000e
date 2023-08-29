source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"

gem 'pg', '~> 1.5', '>= 1.5.3'

gem 'rack-cors'
gem 'kaminari'
gem 'will_paginate', '~> 4.0'
gem 'cancancan'
gem 'rolify'

#Aws setup gems
gem 'aws-sdk-ses'
gem 'aws-sdk-s3'
gem 'aws-sdk-rails'
gem 'fog-aws'
gem 'settingslogic'
gem "sendgrid-ruby"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-rails_csrf_protection'
gem 'carrierwave'
gem 'omniauth-google-oauth2'
gem 'slim', '~> 3.0', '>= 3.0.6'
# Authentication of user [https://github.com/heartcombo/devise]
gem 'devise'
gem "chartkick"
gem "groupdate"

# Fast Json - Json api serialization
gem 'fast_jsonapi'

gem "searchkick"
gem 'elasticsearch', '~> 8.0', '>= 8.0.1'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"
gem 'stripe', '~> 8.6'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
gem "pry"

# Hotwire's modest JavaScript fberamework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

#Secure authentication using JSON Web Tokens
gem 'devise-jwt'
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'
gem 'simple_command'

# Schedule Jobs to do in the background [https://github.com/sidekiq/sidekiq]
gem 'sidekiq', '~> 7.1', '>= 7.1.2'

gem 'rolify'
gem 'audited'
gem 'paper_trail'
gem "pretender"

# Use Redis adapter to run Action Cable in production
gem "redis"
gem 'redis-client'

# Error Monitoring logs [https://github.com/rollbar/rollbar-gem]
gem 'rollbar'


# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

gem 'sinatra', :require => nil
gem 'faker'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', require: false
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'capybara'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem "jsbundling-rails", "~> 1.1"

gem "cssbundling-rails", "~> 1.2"
