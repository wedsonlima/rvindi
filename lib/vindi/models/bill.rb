# frozen_string_literal: true

module Vindi
  # Bill
  #
  # @example
  #
  #   bill = Vindi::Bill.find(1)
  #   bill.charges
  #
  # @example
  #
  #   subscription = Vindi::Subscription.find(1)
  #   bills = subscription.bills
  #
  class Bill < Model
    belongs_to :customer
    belongs_to :period
    belongs_to :subscription
    belongs_to :payment_profile
    # belongs_to :payment_condition

    has_many :bill_items
    has_many :charges
  end
end
