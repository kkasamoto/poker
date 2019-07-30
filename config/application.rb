require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Poker
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.paths.add 'app/services/hand', eager_load: true
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb'), eager_load: true
  end
end
