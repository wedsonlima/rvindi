# frozen_string_literal: true

module Vindi
  # Bill Item
  #
  # @example
  #
  #   bill = Vindi::Bill.find(1)
  #   bill_items = bill.items
  #
  class BillItem < Model
    belongs_to :product
    belongs_to :product_item
    belongs_to :discount

    # has_many :usages
  end
end
