# frozen_string_literal: true

module Vindi
  # Customer Subscriptions
  #
  # @example
  #
  #   subscription = Vindi::Subscription.find(1)
  #   subscription.customer
  #
  #   subscription = Vindi::Subscription.create customer: customer
  # plan: plan, installments: 1
  #   subscription.customer
  #   subscription.plan
  #   subscription.product
  #   subscription.price
  #
  class Subscription < Model
    belongs_to :customer
  end
end
