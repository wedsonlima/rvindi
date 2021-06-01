# frozen_string_literal: true

module Vindi
  # Base model to vindi resources.
  class Model
    include Her::Model

    # @example Active subscriptions
    #   @subscriptions = Vindi::Subscription.active
    #
    scope :active,    -> { where(status: :active) }
    scope :inactive,  -> { where(status: :inactive) }
    scope :archived,  -> { where(status: :archived) }
    scope :canceled,  -> { where(status: :canceled) }

    # @example Active Customers paginated
    #
    #   @customers = Vindi::Customer.active.per_page(5).page(2)
    #
    scope :page,      ->(page) { where(page: page) }
    scope :per_page,  ->(per_page) { where(per_page: per_page) }

    # @example Active Customers ordered by name
    #   @customers = Vindi::Customer.active.order_by(:name, :asc)
    #
    scope :order_by, ->(attr_name, order = :desc) { where(sort_by: attr_name, sort_order: order) }

    parse_root_in_json true, format: :active_model_serializers

    store_metadata :_metadata

    before_validation

    # Validate record before save and after the request
    # put the errors in the right places.
    #
    # @example A subscription without a customer
    #
    #   @subscription = Vindi::Subscription.new.tap do |s|
    #     s.plan_id = plan.id
    #     s.payment_method_code = "credit_card"
    #     s.save
    #   end
    #
    #   @subscription.errors.full_messages # ["Customer can't be blank"]
    #
    # @example A subscription with invalid plan
    #
    #   @subscription = Vindi::Subscription.new.tap do |s|
    #     s.customer_id = customer.id
    #     s.plan_id = 1
    #     s.payment_method_code = "credit_card"
    #     s.save
    #   end
    #
    #   @subscription.errors.full_messages # ["Plan nao encontrado"]
    #
    def save
      super

      response_errors.any? && errors.clear && response_errors.each do |re|
        errors.add re[:attribute], re[:type], message: re[:message]
      end

      return false if errors.any?

      self
    end

    # @private
    def valid?
      super && response_errors.empty?
    end

    class << self
      # @example First Customer
      #   @customer = Vindi::Customer.first
      #
      # @example First two customers
      #   @customers = Vindi::Customer.first(2)
      #
      def first(limit = 1)
        records = order_by(:created_at, :asc).per_page(limit)

        return records[0] if limit == 1

        records
      end

      # @example Last customer
      #   @customer = Vindi::Customer.last
      #
      # @example Last two customers
      #   @customers = Vindi::Customer.last(2)
      #
      def last(limit = 1)
        records = order_by(:created_at, :desc).per_page(limit)

        return records[0] if limit == 1

        records
      end
    end
  end
end
