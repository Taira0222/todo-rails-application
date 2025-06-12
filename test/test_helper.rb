ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "omniauth-google-oauth2"
Minitest::Reporters.use!
OmniAuth.config.test_mode = true



module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Mockを上書き可能
    def mock_google_oauth(hash = OmniAuth.config.mock_auth[:google_oauth2])
      OmniAuth.config.mock_auth[:google_oauth2] = hash
    end
  end
end
