class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.all_markets(Market.all)
  end

  def show
    begin
      render json: MarketSerializer.show_market(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      render json: {
        errors: [
          {
            status: '404',
            detail: exception.message
          }
        ]
    }, status: :not_found
    end
  end

  def search
    markets = Market.all
    if params[:state].present? && params[:city].present? && params[:name].present? # state, city, name
      results = markets.where(state: params[:state], city: params[:city], name: params[:name])
      render json: MarketSerializer.all_markets(results)
    elsif params[:state].present? && params[:city].present? && !params[:name].present? # state, city
      results = markets.where(state: params[:state], city: params[:city])
      render json: MarketSerializer.all_markets(results)
    elsif params[:state].present? && params[:name].present?  && !params[:city].present? # state, name
      results = markets.where(state: params[:state], name: params[:name])
      render json: MarketSerializer.all_markets(results)
    elsif params[:name].present? && !params[:city].present? && !params[:state].present? # name
      results = markets.where("name ILIKE ?", params[:name])
      render json: MarketSerializer.all_markets(results)
    elsif params[:state].present? && !params[:name].present? && !params[:city].present? # state
      results = markets.where("state ILIKE ?", params[:state])
      render json: MarketSerializer.all_markets(results)
    elsif params[:city].present? && !params[:state].present? && !params[:name].present? # doesn't allow city
      render json: {
        errors: [
          {
            status: '422',
            detail: 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.'
          }
        ]
      }, status: 422

    elsif params[:city].present? && params[:name].present? && !params[:state].present? # doesn't allow city and name
      render json: {
        errors: [
          {
            status: '422',
            detail: 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.'
          }
        ]
      }, status: 422
    end
  end

  def nearest_atms
    market = Market.find(params[:id])
    lat = market.lat
    lon = market.lon
    key = Rails.application.credentials.tomtom[:key]

    conn = Faraday.new(url: "https://api.tomtom.com") do |faraday|
      faraday.headers["key"] = key
    end

    response = conn.get("/search/2/nearbySearch/.json?key=#{key}&lat=#{lat}&lon=#{lon}")
    
    json = JSON.parse(response.body, symbolize_names: true)

    sorted_results = json.sort_by { |results| [:dist] }
    render json: AtmSerializer.all_atms(sorted_results[1])
  end
end