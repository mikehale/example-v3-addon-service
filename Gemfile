source "https://rubygems.org"
ruby "2.5.1"

gem "multi_json"
gem "oj"
gem "pg"
gem "pliny", "~> 0.27"
gem "pry"
gem "puma", "~> 3"
gem "rack-ssl"
gem "rack-timeout", "~> 0.4"
gem "rake"
gem "rollbar"
gem "sequel", "~> 5.0"
gem "sequel-paranoid"
gem "sequel_pg", "~> 1.6", require: "sequel"
gem "sinatra", [">= 1.4", "< 3.0"], require: "sinatra/base"
gem "sinatra-contrib", require: ["sinatra/namespace", "sinatra/reloader"]
gem "sinatra-router"
gem "sucker_punch"
gem "que", github: "heroku/que", branch: "transaction-tolerant-0.14.3"
gem "activesupport", require: ["active_support", "active_support/inflector", "active_support/core_ext/numeric"]
gem "excon"
gem "attr_vault", "~> 2.1.0"

group :development, :test do
  gem "foreman"
  gem "kensa"
  gem "fabrication"
  gem "pry-byebug"
  gem "rubocop", "~> 0.52.1", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "committee"
  gem "database_cleaner"
  gem "dotenv"
  gem "rack-test"
  gem "rspec"
  gem "simplecov", require: false
end
