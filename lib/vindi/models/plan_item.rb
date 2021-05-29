# frozen_string_literal: true

module Vindi
  # Plan Items
  #
  class PlanItem < Model
    belongs_to :plan

    has_one :product
  end
end
