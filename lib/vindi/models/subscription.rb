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
  class Subscription < Model
    belongs_to :customer
    belongs_to :plan

    attributes :plan_id, :customer_id, :payment_method_code

    validates :plan_id, :customer_id, :payment_method_code, presence: true

    scope :inactive, -> { canceled }

    # @example Cancel a subscription
    #
    #   @subscription = Vindi::Customer.find(1).subscriptions.active.last
    #   @subscription.cancel!
    #
    def cancel!
      destroy
    end

    # @example Reactivate a subscription
    #
    #   @subscription = Vindi::Customer.find(1).subscriptions.inactive.last
    #   @subscription.reactivate!
    #
    def reactivate!
      # REVIEW: There's another way to do this using `custom_post` but the result breaks the normal
      # flow because the API returns the root resource as singular name and HER expects to be a plural.

      self.class.post_raw(:reactivate, id: id) do |parsed_data, _|
        assign_attributes parsed_data[:data][self.class.collection_path.singularize.to_sym]
      end
    end
  end
end
