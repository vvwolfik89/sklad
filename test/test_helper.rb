ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/rails'
require 'capybara/rails'
require 'mocha/minitest'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include Devise::Test::IntegrationHelpers
  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
