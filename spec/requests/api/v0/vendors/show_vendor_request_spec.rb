require 'rails_helper'

RSpec.describe 'Show Vendor Request', type: :request do

  it 'returns a single vendor JSON Serializer success' do
    vendor1 = FactoryBot.create(:vendor)
    vendor2 = FactoryBot.create(:vendor)

    get "/api/v0/vendors/#{vendor1.id}"

    vendor = JSON.parse(response.body, symbolize_names: true)[:data]

    #-------------Vendor Response-------------------
    expect(response).to be_successful
    expect(response.status).to eq(200)

    #-------------Vendor Data/Attributes-------------------
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
    expect(vendor[:relationships][:markets][:data].count).to eq(0)
  end

  it 'returns a 404 error for an invalid vendor id' do
    vendor1 = FactoryBot.create(:vendor)

    #visit the wrong vendor id
    get "/api/v0/vendors/6"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to have_key(:errors)
    expect(error).to be_a(Hash)

    expect(error[:errors]).to be_an(Array)
    expect(error[:errors][0][:status]).to eq("404")
    expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=6")
  end
end