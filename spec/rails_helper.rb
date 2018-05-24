require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/email/rspec'
require 'cancan/matchers'
require 'sidekiq/testing'

Sidekiq::Testing.fake!


Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!



RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryBot::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include(OmniauthMacros)

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end


  Capybara.register_driver :chrome do |app|
    # optional
    client = Selenium::WebDriver::Remote::Http::Default.new
    # optional
    client.timeout = 120
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client)
  end

  OmniAuth.config.test_mode = true

  Capybara.javascript_driver = :chrome
end