# frozen_string_literal: true

module Vindi
  module Middleware
    # Vindi Response Parser
    #
    # Saves metadata info into metadata object.
    class ResponseParser < Faraday::Response::Middleware
      def on_complete(env)
        env[:body] = parse(env[:status] == 204 ? "{}" : env)

        Vindi::RateLimit.update env[:body].dig :metadata, :rate_limit
      end

      def parse(env)
        json = Her::Middleware::ParseJSON.new.parse_json env[:body]
        errors = translate_errors_to_activemodel_style(json.delete(:errors) || [])
        metadata = (json.delete(:metadata) || {}).merge(extract_response_headers_info(env[:response_headers]))

        {
          data: json,
          errors: errors,
          metadata: metadata
        }
      end

      def translate_errors_to_activemodel_style(errors)
        errors.map do |e|
          {
            attribute: e[:parameter],
            type: e[:id] == "invalid_parameter" ? :invalid : e[:id],
            message: e[:message]
          }
        end
      end

      def extract_response_headers_info(response_headers)
        {
          items: response_headers[:total],
          link: response_headers[:link],
          rate_limit: {
            limit: response_headers[:"rate-limit-limit"],
            reset: Time.at(response_headers[:"rate-limit-reset"].to_i),
            remaining: response_headers[:"rate-limit-remaining"]
          }
        }
      end
    end
  end
end
