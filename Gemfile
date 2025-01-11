# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "rails-i18n", "~> 8.0.0"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
# gem "solid_queue"
# gem "solid_cable"

gem "bootsnap", require: false

# gem "rack-cors"

gem "alba"
gem "data_migrate"
gem "litestream"

gem "google-cloud-error_reporting", group: :production

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "rspec-rails", "~> 7.1.0"
  gem "factory_bot_rails"
  gem "rubocop-rails", require: false

  gem "ruby-lsp"
end
