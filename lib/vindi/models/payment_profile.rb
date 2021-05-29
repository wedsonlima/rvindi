# frozen_string_literal: true

module Vindi
  # Payment Profiles
  #
  class PaymentProfile < Model
    belongs_to :customer
  end
end
