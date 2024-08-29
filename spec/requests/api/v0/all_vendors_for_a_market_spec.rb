require 'rails_helper'

RSpec.describe 'All Vendors for a Market Request', type: :request do
  it 'returns all markets JSON Serializer' do
    market1 = FactoryBot.create(:market)
    market2 = FactoryBot.create(:market)

    vendor1 = FactoryBot.create(:vendor)
    vendor2 = FactoryBot.create(:vendor)
    vendor3 = FactoryBot.create(:vendor)

    MarketVendor.create(market: market1, vendor: vendor1)
    MarketVendor.create(market: market1, vendor: vendor2)
    MarketVendor.create(market: market2, vendor: vendor3)

    get "/api/v0/markets/#{market1.id}/vendors"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors.count).to eq(2)

    vendors.each do |vendor|
      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be(true).or be(false)

      #-------------Nested Relationship Data-------------------
      expect(vendor).to have_key(:relationships)
      expect(vendor[:relationships]).to be_a(Hash)
      
      expect(vendor[:relationships]).to have_key(:markets)
      expect(vendor[:relationships][:markets]).to be_a(Hash)
      
      expect(vendor[:relationships][:markets]).to have_key(:data)
      expect(vendor[:relationships][:markets][:data]).to be_an(Array)
    end

    first_vendor = vendors.first
    expect(first_vendor[:attributes][:name]).to eq(vendor1.name)
    expect(first_vendor[:attributes][:description]).to eq(vendor1.description)
    expect(first_vendor[:attributes][:contact_name]).to eq(vendor1.contact_name)
    expect(first_vendor[:attributes][:contact_phone]).to eq(vendor1.contact_phone)
    expect(first_vendor[:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)

    expect(first_vendor[:relationships][:markets][:data][0][:id]).to eq market1.id
    expect(first_vendor[:relationships][:markets][:data][0][:name]).to eq market1.name
    expect(first_vendor[:relationships][:markets][:data][0][:type]).to eq "market"
  end

  it "returns a 404 error for an invalid market id" do
    market1 = FactoryBot.create(:market)
    vendor1 = FactoryBot.create(:vendor)
    vendor2 = FactoryBot.create(:vendor)
    MarketVendor.create(market: market1, vendor: vendor1)
    MarketVendor.create(market: market1, vendor: vendor2)

    #visit the wrong market id
    get "/api/v0/markets/6/vendors"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to have_key(:errors)
    expect(error).to be_a(Hash)

    expect(error[:errors]).to be_an(Array)
    expect(error[:errors][0][:status]).to eq("404")
    expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=6")
  end
end