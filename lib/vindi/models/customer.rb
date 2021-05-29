# frozen_string_literal: true

require_relative "subscription"

module Vindi
  # Customers
  #
  # @example
  #
  #   customer = Vindi::Customer.find(1)
  #   customer.subscriptions
  #   customer.subscriptions.active
  #
  #   customer = Vindi::Customer.find_by(email: "gandalf@middleearth.com")
  #   customer.name
  #   customer.name = "Gandalf the White"
  #   customer.save
  #
  class Customer < Model
    scope :contains_name, ->(name) { where(contains: { name: name }) }

    has_one :address, class_name: "Vindi::Address"
    # has_many :subscriptions, class_name: "Vindi::Subscription", parent_as_param: true, group_params_with: :query

    def subscriptions
      Vindi::Subscription.where(customer_id: id)
    end
  end
end
