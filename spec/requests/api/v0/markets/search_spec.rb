require 'rails_helper'

RSpec.describe 'Markets Search', type: :request do
  it 'returns all valid market search results by name' do
    create_list(:market, 10)

    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?name=Nob Hill Growers' Market", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(search_results).to be_an(Array)

    search_results.each do |market|
      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)
      expect(market[:attributes][:name]).to eq("Nob Hill Growers' Market")

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)
      expect(market[:attributes][:street]).to eq("Lead & Morningside SE")

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)
      expect(market[:attributes][:city]).to eq("Albuquerque")

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)
      expect(market[:attributes][:county]).to eq("Bernalillo")

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)
      expect(market[:attributes][:state]).to eq("New Mexico")

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to eq nil

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)
      expect(market[:attributes][:lat]).to eq("35.077529")

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)
      expect(market[:attributes][:lon]).to eq("-106.600449")

      #-------------Nested Relationship Data-------------------
      expect(market).to have_key(:relationships)
      expect(market[:relationships]).to be_a(Hash)

      expect(market[:relationships]).to have_key(:vendors)
      expect(market[:relationships][:vendors]).to be_a(Hash)

      expect(market[:relationships][:vendors]).to have_key(:data)
      expect(market[:relationships][:vendors][:data]).to be_an(Array)
    end
  end

  it 'returns all valid market search results by state' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
    market2 = Market.create!( name: "Farmer's Market",
                      street: "Hollywood blvd",
                      city: "Point Pleasant",
                      county: "Ocean",
                      state: "Virginia",
                      zip: 12345,
                      lat: "10.192837",
                      lon: "-32.918372"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?state=New Mexico", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(search_results.first[:attributes][:name]).to eq(market1.name)
  end

  it 'returns all valid market search results by state and city' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
    market2 = Market.create!( name: "Farmer's Market",
                      street: "Hollywood blvd",
                      city: "Point Pleasant",
                      county: "Ocean",
                      state: "Virginia",
                      zip: 12345,
                      lat: "10.192837",
                      lon: "-32.918372"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?state=New Mexico&city=Albuquerque", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(search_results.first[:attributes][:name]).to eq(market1.name)
  end

  it 'returns all valid market search results by state, city, and name' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
    market2 = Market.create!( name: "Farmer's Market",
                      street: "Hollywood blvd",
                      city: "Point Pleasant",
                      county: "Ocean",
                      state: "Virginia",
                      zip: 12345,
                      lat: "10.192837",
                      lon: "-32.918372"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?state=New Mexico&city=Albuquerque&name=Nob Hill Growers' Market", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(search_results.first[:attributes][:name]).to eq(market1.name)
  end

  it 'returns all valid market search results by state and name' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
    market2 = Market.create!( name: "Farmer's Market",
                      street: "Hollywood blvd",
                      city: "Point Pleasant",
                      county: "Ocean",
                      state: "Virginia",
                      zip: 12345,
                      lat: "10.192837",
                      lon: "-32.918372"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?state=New Mexico&name=Nob Hill Growers' Market", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(search_results.first[:attributes][:name]).to eq(market1.name)
  end

  it 'returns an empty array if the search does not match the name' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?name=Gamestop", headers: headers
    expect(response.status).to eq(200)

    search_results = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(search_results).to eq([])
  end

  it 'returns an error if invalid parameters are sent (city)' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?city=Albuquerque", headers: headers
    expect(response.status).to eq(422)

    error = JSON.parse(response.body, symbolize_names: true)
    
    expect(error).to have_key(:errors)
    expect(error).to be_a(Hash)

    expect(error[:errors]).to be_an(Array)
    expect(error[:errors][0][:status]).to eq("422")
    expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  end

  it 'returns an error if invalid parameters are sent (city and name)' do
    market1 = Market.create!( name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: nil,
                      lat: "35.077529",
                      lon: "-106.600449"
                      )
                            
    headers = {"CONTENT_TYPE" => "application/json"}
    
    get "/api/v0/markets/search?city=Albuquerque&name=Nob Hill Growers' Market", headers: headers
    expect(response.status).to eq(422)
    
    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to have_key(:errors)
    expect(error).to be_a(Hash)

    expect(error[:errors]).to be_an(Array)
    expect(error[:errors][0][:status]).to eq("422")
    expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  end
end