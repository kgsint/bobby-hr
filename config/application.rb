require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BobbyHr1
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))
    config.time_zone = "Asia/Yangon"
    # session name
    config.session_store :cookie_store, key: "bobby_hr_sess"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
