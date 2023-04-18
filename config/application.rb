require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sklad
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    # где библиотека I18n должна искать наши переводы
    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

    # Разрешенные локали, доступные приложению
    I18n.available_locales = [:en, :ru]

    # устанавливаем локаль по умолчанию на что-либо другое, чем :en
    I18n.default_locale = :ru
  end
end
