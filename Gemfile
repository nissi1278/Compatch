source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "mysql2", "~> 0.5"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "tailwindcss-rails", "~> 4.3.0"
gem "puma"
gem 'activerecord-session_store', "~> 2.2.0"
gem "jsbundling-rails", "~> 1.3.0"
gem "cssbundling-rails", "~> 1.4.0"
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "htmlbeautifier", "~>1.4.3"
  gem "guard", "~> 2.19.1"
  gem "guard-rspec", "~> 4.7.3", require: false
  gem "guard-rubocop", "~> 1.5.0", require: false
  gem "rspec-rails", "~> 8.0.2"
  gem "dotenv-rails", "~> 3.1.8"
  gem "pry-byebug", "~> 3.11.0"
  gem "brakeman", require: false
  gem "rubocop", "~>1.78.0"
  gem "rubocop-performance","~>1.25.0"
  gem "rubocop-rails","~>2.32.0"
  gem "rubocop-rspec", "~>3.6.0"
end

group :development do
  gem "web-console"
  gem "spring"
  gem "solargraph", "~> 0.56.0", require: false
  gem "solargraph-rails", "~> 1.2.4", require: false
  gem "solargraph-rspec", "~> 0.5.2", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
