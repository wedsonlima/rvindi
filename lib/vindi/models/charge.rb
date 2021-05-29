# frozen_string_literal: true

module Vindi
  # Bill Charges
  #
  class Charge < Model
    belongs_to :bill
  end
end
