require "simplecov"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "omniauth-google-oauth2"
Minitest::Reporters.use!
OmniAuth.config.test_mode = true

require "minitest/autorun"



module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def todo_create(user,
                    title,
                    description: "description",
                    due_date: Time.zone.now.to_date,
                    due_time: Time.zone.now.strftime("%H:%M"),
                    has_time: true)
      Todo.create(
        user: user,
        title: title,
        description: description,
        due_date: due_date,
        due_time: due_time,
        has_time: has_time
      )
    end
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # Mockを上書き可能
  def mock_google_oauth(hash = OmniAuth.config.mock_auth[:google_oauth2])
    OmniAuth.config.mock_auth[:google_oauth2] = hash
  end
  # ログイン失敗
  def fail_login
    post user_session_path, params: { user: { email: "",
                                            password: "" } }
  end
  # ログイン成功
  def log_in_as(user, password: "password", remember_me: "1")
    post new_user_session_path, params: { user: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
  end
end
