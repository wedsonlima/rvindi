# frozen_string_literal: true

require "vindi"

Vindi.config do |c|
  c.sandbox = true
  c.api_key = ENV["VINDI_API_KEY"]
end
