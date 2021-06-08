# frozen_string_literal: true

require "spec_helper"

describe Vindi::Plan do
  describe "List" do
    it "active" do
      VCR.use_cassette("plan/list_active") do
        ap = Vindi::Plan.active.where(name: "'The One Plan'")
        expect(ap.length).to eq(0)
      end
    end
  end

  describe "Create" do
    it "The One Plan" do
      palantir = nil
      VCR.use_cassette("product/find_palantir") do
        palantir = Vindi::Product.find_by(code: "palantir")
      end

      VCR.use_cassette("plan/create_the_one_plan") do
        plan = Vindi::Plan.new.tap do |p|
          p.code = "the-one-plan"
          p.name = "The One Plan"
          p.description = "The One Plan To Rule Them All"
          p.period = "monthly"
          p.recurring = true
          p.plan_items = [
            {
              cycles: nil, # untill the end of time
              product_id: palantir.id
            }
          ]
          p.save
        end

        expect(plan.id.present?).to be true
      end
    end
  end

  describe "Find" do
    it "The One Plan" do
      VCR.use_cassette("plan/find_the_one_plan") do
        expect(Vindi::Plan.find_by(code: "the-one-plan").name).to eq("The One Plan")
      end
    end
  end

  describe "Update" do
    it "name" do
      plan = nil

      VCR.use_cassette("plan/find_the_one_plan") do
        plan = Vindi::Plan.find_by(code: "the-one-plan")

        expect(plan.name).to eq("The One Plan")
      end

      VCR.use_cassette("plan/update_plan") do
        plan.name = "The One Monthly Plan"
        plan.save

        expect(plan.name).to eq("The One Monthly Plan")
      end
    end
  end
end
