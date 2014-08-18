require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Devdev
  class Application < Rails::Application
    config.i18n.default_locale = :fr
    config.encoding = "utf-8"
  end
end
