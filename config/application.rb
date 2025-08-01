require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TodoApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for <example class=""></example>
    config.autoload_lib(ignore: %w[assets tasks])

    # testを生成するとデフォルトでminitestが生成される
    config.generators do |g|
      g.test_framework :minitest, spec: false
    end

    # アプリのデフォルトの言語を日本語に設定
    config.i18n.default_locale = :ja


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
