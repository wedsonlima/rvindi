# frozen_string_literal: true

require_relative "vindi/version"
require_relative "vindi/setup"
require_relative "vindi/rate_limit"

require_relative "vindi/core_extensions/her_with_query_filter"
require_relative "vindi/model"

require_relative "vindi/address"
require_relative "vindi/customer"
require_relative "vindi/subscription"

module Vindi
  class Error < StandardError; end
end

require "httplog" # require this *after* your HTTP gem of choice

HttpLog.configure do |config|
  config.log_headers = true
end
