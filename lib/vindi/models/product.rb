# frozen_string_literal: true

module Vindi
  # Products
  #
  # @example Listing active productts
  #
  #   products = Vindi::Product.active
  #
  # @example Create a product
  #
  #   product = Vindi::Product.new.tap do |p|
  #     p.name: "Tijolo"
  #     p.description: "Muito bom. Mas tijolo.. nao revida"
  #     p.pricing_schema: { price: 42.42 }
  #   end
  #
  #   product.save
  #
  class Product < Model
    belongs_to :pricing_schema

    has_many :plans
  end
end
