ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "capybara/poltergeist"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl

  def inject_session(hash)
    Warden.on_next_request do |proxy|
      hash.each do |key, value|
        proxy.raw_session[key] = value
      end
    end
  end
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

Capybara.javascript_driver = :poltergeist
ActiveRecord::Migration.maintain_test_schema!
