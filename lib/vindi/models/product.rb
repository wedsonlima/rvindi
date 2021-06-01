# frozen_string_literal: true

module Vindi
  # Products
  #
  # @example Active productts
  #
  #   products = Vindi::Product.active
  #
  # @example Create a product
  #
  #   palantir = Vindi::Product.new.tap do |p|
  #     p.code = "palantir"
  #     p.name = "Palantir"
  #     p.description = "The Twitch of Istari folk"
  #     p.pricing_schema = { price: 42.42 }
  #     p.save
  #   end
  #
  class Product < Model
    belongs_to :pricing_schema

    has_many :plans
  end
end
