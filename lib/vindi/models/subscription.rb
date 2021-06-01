# frozen_string_literal: true

module Vindi
  # Customer Subscriptions
  #
  # @example Subscribe a customer to a plan
  #
  #   @subscription = Vindi::Subscription.new.tap do |s|
  #     s.customer_id = customer.id
  #     s.plan_id = plan.id
  #     s.payment_method_code = "credit_card"
  #     s.save
  #   end
  #
  # @example Cancel a subscription
  #
  #   @subscription = Vindi::Customer.find(1).subscriptions.active.last
  #   @subscription.cancel!
  #
  class Subscription < Model
    belongs_to :customer
    belongs_to :plan

    attributes :plan_id, :customer_id, :payment_method_code

    validates :plan_id, :customer_id, :payment_method_code, presence: true

    def cancel!
      destroy
    end
  end
end
