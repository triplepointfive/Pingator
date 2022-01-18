source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 6.0.4'
gem 'pg'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.4.2', require: false

gem 'grape'
gem 'mutations'
gem 'bunny'
gem 'concurrent-ruby'
gem 'net-ping'
gem 'config'
gem 'dry-initializer'

group :development do
  gem 'listen', '~> 3.2'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'bunny-mock'
end
