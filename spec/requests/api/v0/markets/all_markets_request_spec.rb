require 'rails_helper'

RSpec.describe 'AllMarketsRequest', type: :request do
  it 'returns all markets JSON Serializer' do
    create_list(:market, 10)

    get '/api/v0/markets'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets.count).to eq(10)

    markets.each do |market|
      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

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
    end
  end
end