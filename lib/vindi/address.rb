# frozen_string_literal: true

module Vindi
  # Address
  class Address < Model
    belongs_to :customer
  end
end
