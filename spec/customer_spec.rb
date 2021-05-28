# frozen_string_literal: true

require "vindi"

describe Vindi::Customer do
  it "Find a customer by email" do
    expect(Vindi::Customer.find_by(email: "wedson@mail.com").name).to eq("Wedson Lima")
  end

  it "Don't find a customer by email" do
    expect(Vindi::Customer.find_by(email: "saruman@therealboss.com")).to eq(nil)
  end
end
