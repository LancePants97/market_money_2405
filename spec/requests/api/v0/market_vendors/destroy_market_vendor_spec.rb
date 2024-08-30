require 'rails_helper'

RSpec.describe 'Destroy a Market Vendor', type: :request do
  
  it "can destroy a market vendor" do
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)
    market_vendor = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)

    delete "/api/v0/market_vendors", params: { market_id: market1.id, vendor_id: vendor1.id }

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
  end

  it "returns an error 404 for an unsuccessful association" do
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')
    market_vendor = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)

    delete "/api/v0/market_vendors", params: { vendor_id: vendor1.id, market_id: 999 }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.body).to include('MarketVendor association not found')
  end

  it "returns an error 404 for an unsuccessful param check => leading to no association" do
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')
    market_vendor = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)

    delete "/api/v0/market_vendors", params: { vendor_id: vendor1.id }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.body).to include('MarketVendor association not found')
  end
end