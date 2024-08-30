require 'rails_helper'

RSpec.describe 'Create a Market Vendor', type: :request do

  it "can create a new market vendor" do
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)


    post "/api/v0/market_vendors", params: { market_id: market1.id, vendor_id: vendor1.id }

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(response.body).to include('Successfully added vendor to market')
  end

  it "returns an error 400 for an unsuccessful market vendor creation (no market_id)" do
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)

    post "/api/v0/market_vendors", params: { vendor_id: vendor1.id }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(response.body).to include('Market ID and Vendor ID must be provided')
  end

  it "returns an error 400 for an unsuccessful market vendor creation (no vendor_id)" do
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')

    post "/api/v0/market_vendors", params: { market_id: market1.id }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(response.body).to include('Market ID and Vendor ID must be provided')
  end

  it "returns an error 404 for an unsuccessful market vendor creation (market not found)" do
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)

    post "/api/v0/market_vendors", params: { market_id: 999, vendor_id: vendor1.id }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.body).to include('Market not found')
  end

  it "returns an error 404 for an unsuccessful market vendor creation (vendor not found)" do
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')

    post "/api/v0/market_vendors", params: { market_id: market1.id, vendor_id: 999 }

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.body).to include('Vendor not found')
  end

  it "returns an error 422 for an unsuccessful market vendor creation (association already exists)" do
    market1 = Market.create(name: 'Walgreens', street: '1234 W. 1st St.', city: 'Chicago', county: 'Chiraq', state: 'IL', zip: '60601', lat: '41.8781', lon: '87.6298')
    vendor1 = Vendor.create(name: 'The Dealer', description: 'He sells drugs', contact_name: 'DrugDude420', contact_phone: '555-555-5555', credit_accepted: false)
    MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)

    post "/api/v0/market_vendors", params: { market_id: market1.id, vendor_id: vendor1.id }

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    expect(response.body).to include("Validation failed: Market vendor association between market with market_id=#{market1.id} and vendor_id=#{vendor1.id} already exists")
  end
end