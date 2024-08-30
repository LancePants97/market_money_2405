require 'rails_helper'

RSpec.describe 'Destroy a Vendor', type: :request do
  it "can destroy a vendor" do
    vendor1 = Vendor.create(name: 'Theo', description: 'Theo is a great vendor', contact_name: 'Theo', contact_phone: '555-555-5555', credit_accepted: true)

    delete "/api/v0/vendors/#{vendor1.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Vendor.count).to eq(0)
  end

  it "returns an error 404 for an unsuccessful vendor deletion" do
    vendor1 = Vendor.create(name: 'Theo', description: 'Theo is a great vendor', contact_name: 'Theo', contact_phone: '555-555-5555', credit_accepted: true)

    delete "/api/v0/vendors/16"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to have_key(:errors)
    expect(error).to be_a(Hash)

    expect(error[:errors]).to be_an(Array)
    expect(error[:errors][0][:status]).to eq("404")
    expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=16")
  end

  it "destroys the associated market_vendors when a vendor is destroyed" do
    vendor1 = Vendor.create(name: 'Theo', description: 'Theo is a great vendor', contact_name: 'Theo', contact_phone: '555-555-5555', credit_accepted: true)
    market1 = Market.create(name: 'Market 1', street: '123 Market St', city: 'Denver', county: 'Denver County', state: 'CO', zip: '80202', lat: '39.750783', lon: '-104.996439')
    market_vendor = MarketVendor.create(vendor_id: vendor1.id, market_id: market1.id)

    delete "/api/v0/vendors/#{vendor1.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Vendor.count).to eq(0)
    expect(MarketVendor.count).to eq(0)
  end
end