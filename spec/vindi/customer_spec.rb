# frozen_string_literal: true

require "spec_helper"

describe Vindi::Customer do
  describe "List" do
    it "active customers" do
      VCR.use_cassette("customer/list_active") do
        expect(Vindi::Customer.active.where(name: "Gandalf").count).to eq(0)
      end
    end
  end

  describe "Create" do
    it "customer named Gandalf" do
      VCR.use_cassette("customer/create_gandalf") do
        gandalf = Vindi::Customer.new.tap do |c|
          c.code = "gandalf"
          c.name = "Gandalf the Grey"
          c.email = "gandalf@middlearth.io"
          c.save
        end

        expect(gandalf.id.present?).to be true
      end
    end
  end

  describe "Find" do
    it "by email" do
      VCR.use_cassette("customer/find_gandalf_by_email") do
        expect(Vindi::Customer.find_by(email: "gandalf@middlearth.io").name).to eq("Gandalf the Grey")
      end
    end

    it "none by email" do
      VCR.use_cassette("customer/find_saruman_by_email") do
        expect(Vindi::Customer.find_by(email: "saruman@middlearth.io")).to eq(nil)
      end
    end
  end

  describe "Update" do
    it "Gandalf's email" do
      gandalf = nil

      VCR.use_cassette("customer/find_gandalf_by_code") do
        gandalf = Vindi::Customer.find_by(code: "gandalf")

        expect(gandalf.code).to eq("gandalf")
      end

      VCR.use_cassette("customer/update_gandalf") do
        gandalf.email = "gandalfthewhite@middlearth.io"
        gandalf.save

        expect(gandalf.email).to eq("gandalfthewhite@middlearth.io")
      end
    end
  end

  describe "Archive" do
    it "Saruman" do
      saruman = nil

      VCR.use_cassette("customer/create_saruman") do
        saruman = Vindi::Customer.new.tap do |c|
          c.code = "saruman"
          c.name = "Saruamn The White"
          c.email = "sarumanthewhite@middlearth.io"
          c.save
        end

        # There's no active subscription
        expect(saruman.status).to eq("inactive")
      end

      VCR.use_cassette("customer/archive_saruman") do
        saruman.archive!

        expect(saruman.status).to eq("archived")
      end
    end
  end
end
