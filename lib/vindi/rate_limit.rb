# frozen_string_literal: true

module Vindi
  class RateLimitError < StandardError; end

  # Vindi API calls has a rate limit.
  class RateLimit
    class << self
      attr_accessor :rate_limit_limit, :rate_limit_remaining, :rate_limit_reset

      def update(rate = {})
        @rate_limit_limit     = rate[:limit].to_i
        @rate_limit_remaining = rate[:remaining].to_i
        @rate_limit_reset     = Time.at(rate[:reset].to_i)
      end
    end
  end
end
