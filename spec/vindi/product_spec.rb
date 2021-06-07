# frozen_string_literal: true

require "spec_helper"

describe Vindi::Product do
  describe "List" do
    it "active" do
      VCR.use_cassette("product/list_active") do
        ap = Vindi::Product.active.where(name: "Palantir")
        expect(ap.length).to eq(0)
      end
    end
  end

  describe "Create" do
    it "Palantir" do
      VCR.use_cassette("product/create_palantir") do
        product = Vindi::Product.new.tap do |p|
          p.code = "palantir"
          p.name = "Palantir"
          p.description = "The Twitch of Istari folk"
          p.pricing_schema = { price: 42.42 }
          p.save
        end

        expect(product.id.present?).to be true
      end
    end
  end

  describe "Find" do
    it "find Palantir" do
      VCR.use_cassette("product/find_palantir") do
        expect(Vindi::Product.find_by(code: "palantir").name).to eq("Palantir")
      end
    end

    it "don't find One Ring" do
      VCR.use_cassette("product/dont_find_one_ring") do
        expect(Vindi::Product.find_by(code: "one-ring")).to eq(nil)
      end
    end
  end

  describe "Update" do
    it "price" do
      palantir = nil

      VCR.use_cassette("product/find_palantir") do
        palantir = Vindi::Product.find_by(code: "palantir")

        expect(palantir.pricing_schema["price"]).to eq("42.42")
      end

      VCR.use_cassette("product/update_palantir") do
        palantir.pricing_schema = { price: 50 }
        palantir.save

        expect(palantir.pricing_schema["price"]).to eq("50.0")
      end
    end
  end
end
