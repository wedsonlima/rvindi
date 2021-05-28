# frozen_string_literal: true

# Saves the rate limts from Vindi responses.
module Vindi
  module Middleware
    class RateLimitValidation < Faraday::Middleware
      def call(env)
        raise Vindi::RateLimitError, "Rate limit reached" if rate_limit_reached?

        @app.call(env)
      end

      private

      def rate_limit_reached?
        return false unless Vindi::RateLimit.rate_limit_limit

        Vindi::RateLimit.rate_limit_limit <= Vindi::RateLimit.rate_limit_remaining &&
          Vindi::RateLimit.rate_limit_reset > Time.now
      end
    end
  end
end
