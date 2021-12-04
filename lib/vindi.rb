# frozen_string_literal: true

require "dry-configurable"

require "faraday"
require "faraday_middleware"
require "her"

require_relative "vindi/version"
require_relative "vindi/rate_limit"

require_relative "vindi/middleware/rate_limit_validation"
require_relative "vindi/middleware/response_parser"

require_relative "vindi/core_extensions/her_with_query_filter"
require_relative "vindi/core_extensions/her_save_only_changed_attrs"

module Vindi # :nodoc:
  extend Dry::Configurable

  class Error < StandardError; end

  RESOURCE_MODELS = Dir[File.expand_path("vindi/models/**/*.rb", File.dirname(__FILE__))].freeze

  RESOURCE_MODELS.each do |f|
    autoload File.basename(f, ".rb").camelcase.to_sym, f
  end

  VINDI_API_URL = "https://app.vindi.com.br/api/v1"
  VINDI_SANDBOX_API_URL = "https://sandbox-app.vindi.com.br/api/v1"

  # Set sandbox to true in dev mode.
  setting :sandbox, false
  # Set the API KEY to assign the API calls.
  setting :api_key
  # Validates incoming Vindi Webhook calls with the given secret name.
  setting :webhook_secret_name
  # Validates incoming Vindi Webhook calls with the given secret password.
  setting :webhook_secret_password

  # @example
  #   Vindi.configure do |config|
  #     config.sandbox = true
  #     config.api_key = "MY API KEY"
  #     config.webhook_secret_name = "A SECRET NAMEE"
  #     config.webhook_secret_password = "A SECRET PASSWORD"
  #   end
  #
  def self.configure
    super

    her_setup
  end

  def self.api_url
    return VINDI_SANDBOX_API_URL if config.sandbox

    VINDI_API_URL
  end

  # @private
  def self.her_setup
    Her::API.setup url: Vindi.api_url do |conn|
      conn.headers["User-Agent"] = "wedsonlima/rvindi #{Vindi::VERSION}"

      conn.basic_auth config.api_key, ""

      # Request
      conn.use ::Vindi::Middleware::RateLimitValidation
      conn.request :json

      # Response
      conn.response :json, content_type: /\bjson$/
      conn.use ::Vindi::Middleware::ResponseParser

      # Adapter
      conn.adapter Faraday.default_adapter
    end
  end
end
