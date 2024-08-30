require 'rails_helper'

RSpec.describe 'Nearest ATMs', type: :request do
  it 'returns nearest ATMS' do
    market1 = Market.create!( 
                            name: "Nob Hill Growers' Market",
                            street: "Lead & Morningside SE",
                            city: "Albuquerque",
                            county: "Bernalillo",
                            state: "New Mexico",
                            zip: nil,
                            lat: "35.077529",
                            lon: "-106.600449"
                          )

    headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v0/markets/#{market1.id}/nearest_atms", headers: headers, params: JSON.generate(market: market1.id)
    
    search_results = JSON.parse(response.body, symbolize_names: true)[:data]
    binding.pry
  end
end