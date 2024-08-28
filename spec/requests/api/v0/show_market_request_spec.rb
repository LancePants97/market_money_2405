require 'rails_helper'

RSpec.describe 'ShowMarketRequest', type: :request do

  it 'returns a single market JSON Serializer success' do
    market1 = FactoryBot.create(:market)

    get "/api/v0/markets/#{market1.id}"

    market = JSON.parse(response.body, symbolize_names: true)[:data]

    #-------------Market Response-------------------
    expect(response).to be_successful
    expect(response.status).to eq(200)

    #-------------Market Data/Attributes-------------------
    expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      #-------------Nested Relationship Data-------------------
      expect(market).to have_key(:relationships)
      expect(market[:relationships]).to be_a(Hash)

      expect(market[:relationships]).to have_key(:vendors)
      expect(market[:relationships][:vendors]).to be_a(Hash)

      expect(market[:relationships][:vendors]).to have_key(:data)
      expect(market[:relationships][:vendors][:data]).to be_an(Array)
      expect(market[:relationships][:vendors][:data].count).to eq(0)
  end

  it 'returns a 404 error for an invalid market id' do
    market2 = FactoryBot.create(:market)

    #visit the wrong market id
    get "/api/v0/markets/6"
    # binding.pry

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