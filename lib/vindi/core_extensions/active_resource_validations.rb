# frozen_string_literal: true

# Vindi returns error info in a invalid format.
#
# ActiveResource expects { errors: { "attribute": ["messages"] } } and
# vindi returns {"errors":[{"id": "invalid_parameter", "parameter": "name", "message": "message"}]}
#
ActiveResource::Validations.module_eval do
  def load_remote_errors(remote_errors, save_cache = false) #:nodoc:
    errors.from_json translate_errors_to_activemodel_style(remote_errors.response.body), save_cache
  end

  private

  def translate_errors_to_activemodel_style(errors)
    errors = decode_response_errors errors

    { errors: errors.map { |e| [e["parameter"], [e["message"]]] }.to_h }.to_json
  end

  def decode_response_errors(errors)
    ActiveSupport::JSON.decode(errors)["errors"] || []
  rescue; []
  end
end
