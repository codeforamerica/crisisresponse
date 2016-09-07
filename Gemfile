source "https://rubygems.org"

ruby "2.3.1"

gem "autoprefixer-rails"
gem "bourbon", "~> 4.2.0"
gem "carrierwave"
gem "cocoon"
gem "dalli"
gem "deep_cloneable"
gem "delayed_job_active_record"
gem "flutie"
gem "high_voltage"
gem "inline_svg"
gem "kaminari"
gem "neat", "~> 1.7.0"
gem "net-ldap"
gem "newrelic_rpm", ">= 3.9.8"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "pg_search"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 5.0"
gem "rails-assets-bowser", source: "https://rails-assets.org"
gem "rails-assets-jquery-ujs", source: "https://rails-assets.org"
gem "rdiscount"
gem "recipient_interceptor"
gem "ruby-oci8"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "title"
gem "uglifier"

# The released version of this library, v1.4.1,
# contains a bug on Android devices that causes input to be displayed backwards.
# This has been fixed in
# https://github.com/digitalBush/jquery.maskedinput/pull/320,
# but has not been released.
# To get around this, we're including the fix manually through the file
# vendor/assets/javascripts/jquery.maskedinput.js
# Once the fix is included in a new release (likely in version 1.4.2),
# then we'll be able to load the asset through this Gemfile once again.
#
# To check the current version number,
# see https://rails-assets.org/#/components/jquery.maskedinput
#
# gem "rails-assets-jquery.maskedinput", source: "https://rails-assets.org"

group :development do
  gem "refills"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 3.4"
end

group :test do
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "poltergeist"
  gem "rack_session_access"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
end
