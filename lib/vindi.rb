# frozen_string_literal: true

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
  class Error < StandardError; end

  RESOURCE_MODELS = Dir[File.expand_path("vindi/models/**/*.rb", File.dirname(__FILE__))].freeze

  RESOURCE_MODELS.each do |f|
    autoload File.basename(f, ".rb").camelcase.to_sym, f
  end

  # Set sandbox to true in dev mode.
  mattr_accessor :sandbox
  @@sandbox = false

  # Set the API KEY to assign the API calls.
  mattr_accessor :api_key
  @@api_key = false

  # Validates incoming Vindi Webhook calls with the given secret name.
  mattr_accessor :webhook_name
  @@webhook_name = nil

  # Validates incoming Vindi Webhook calls with the given secret password.
  mattr_accessor :webhook_password
  @@webhook_password = nil

  VINDI_API_URL = "https://app.vindi.com.br/api/v1"
  VINDI_SANDBOX_API_URL = "https://sandbox-app.vindi.com.br/api/v1"

  def self.api_url
    return VINDI_SANDBOX_API_URL if @@sandbox

    VINDI_API_URL
  end

  # @example
  #   Vindi.setup do |c|
  #     c.sandbox = true
  #     c.api_key = 'MY API KEY'
  #   end
  #
  def self.config
    yield self

    her_setup
  end

  # @private
  def self.her_setup
    Her::API.setup url: Vindi.api_url do |conn|
      conn.basic_auth Vindi.api_key, ""

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
