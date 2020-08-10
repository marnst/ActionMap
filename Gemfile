# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5' # Make sure that this matches .ruby-version file.

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# Note: Pin the webpacker version to the same version used in package.json
gem 'webpacker', '5.1.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use figaro to easily manage config across environments
gem 'figaro'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use third party sign on authenticate users
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
# Use Haml instead of erb
gem 'haml-rails'

# Google Civic Client
gem 'google-api-client', '~> 0.34'

# Use assets pipeline to serve topojson files.
gem 'sprockets', '4.0.0'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Even though this gem is only required for rake tasks, heroku needs it to run
# pre-receive rake tasks hook so it is included for production environment.
gem 'rubyzip'

gem 'date_validator'

group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: %i[mri mingw x64_mingw]

    # Testing utilities
    gem 'cucumber-rails', require: false
    gem 'database_cleaner'
    gem 'factory_bot'
    gem 'haml_lint'
    gem 'rspec-rails'
    gem 'rubocop-rails'
    gem 'sqlite3'

    # Guard Plugins
    gem 'guard'
    gem 'guard-cucumber', require: false
    gem 'guard-rspec', require: false
    gem 'guard-rubocop', require: false

    # Generate different sizes of favicon from a single image.
    gem 'rails_real_favicon'

    # Report coverage.
    gem 'codecov', require: false
    gem 'simplecov'
end

group :development do
    # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
    gem 'listen', '>= 3.0.5', '< 3.2'
    gem 'web-console', '>= 3.3.0'
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
    # Use postgresql as the database for Active Record in production (Heroku)
    gem 'pg', '>= 0.18', '< 2.0'
    gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
