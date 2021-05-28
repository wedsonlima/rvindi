# frozen_string_literal: true

module Vindi
  # Base model to vindi resources.
  class Model
    include Her::Model

    # @example
    #   @customers = Vindi::Customer.active
    #   # Fetched via GET /customers?query=status=active
    scope :active,    -> { where(status: :active) }
    scope :inactive,  -> { where(status: :inactive) }
    scope :archived,  -> { where(status: :archived) }
    scope :canceled,  -> { where(status: :canceled) }

    # @example
    #   @customers = Vindi::Customer.active.per_page(5).page(2)
    #   # Fetched via GET /customers?query=status=active&per_page=5&page=2
    scope :page,      ->(page) { where(page: page) }
    scope :per_page,  ->(per_page) { where(per_page: per_page) }

    # @example
    #   @customers = Vindi::Customer.active.order_by(:name, :asc)
    #   # Fetched via GET /customers?sort_by=name&sort_order=asc
    scope :order_by,  ->(attr_name, order = :desc) { where(sort_by: attr_name, sort_order: order) }

    parse_root_in_json true, format: :active_model_serializers

    store_metadata :_metadata

    class << self
      # @example
      #   @customer = Vindi::Customer.first
      #   # Fetched via GET /customers?per_page=1&page=1&sort_by=created_at&sort_order=asc
      #
      # @example
      #   @customers = Vindi::Customer.first(2)
      #   # Fetched via GET /customers?per_page=2&page=1&sort_by=created_at&sort_order=asc
      def first(limit = 1)
        records = order_by(:created_at, :asc).per_page(limit)

        return records[0] if limit == 1

        records
      end

      # @example
      #   @customer = Vindi::Customer.last
      #   # Fetched via GET /customers?per_page=1&page=1&sort_by=created_at&sort_order=desc
      #
      # @example
      #   @customers = Vindi::Customer.last(2)
      #   # Fetched via GET /customers?per_page=2&page=1&sort_by=created_at&sort_order=desc
      def last(limit = 1)
        records = order_by(:created_at, :desc).per_page(limit)

        return records[0] if limit == 1

        records
      end
    end
  end
end
