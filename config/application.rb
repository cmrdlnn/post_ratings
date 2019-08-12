# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module PostRatings
  class Application < Rails::Application
    config.load_defaults 5.2

    config.api_only = true

    config.active_record.schema_format = :sql

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
