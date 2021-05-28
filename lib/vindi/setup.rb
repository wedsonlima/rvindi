# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "her"

require_relative "middleware/rate_limit_validation"
require_relative "middleware/response_parser"

Her::API.setup url: "https://sandbox-app.vindi.com.br/api/v1" do |conn|
  conn.basic_auth "CBvMXsVknwj0ZWGX0BqDVmmTPXGsn-Ty-k8M1tVARsI", ""

  # Request
  conn.use ::Vindi::Middleware::RateLimitValidation
  conn.request :json
  # conn.use Faraday::Request::UrlEncoded

  # Response
  conn.response :json, content_type: /\bjson$/
  # conn.use Her::Middleware::DefaultParseJSON
  conn.use ::Vindi::Middleware::ResponseParser

  conn.use :instrumentation

  # Adapter
  # conn.adapter Faraday::Adapter::NetHttp
  conn.adapter Faraday.default_adapter
end
