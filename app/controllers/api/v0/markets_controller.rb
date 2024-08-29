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
    
    if params[:state].present? # state
      markets = markets.where(state: params[:state])
      render json: MarketSerializer.all_markets(markets)
    elsif params[:state].present? && params[:city].present? # state, city
      markets = markets.where(state: params[:state], city: params[:city])
      render json: MarketSerializer.all_markets(markets)
    elsif params[:state].present? && params[:city].present? && params[:name].present? # state, city, name
      markets = markets.where(state: params[:state], city: params[:city], name: params[:name])
      render json: MarketSerializer.all_markets(markets)
    elsif params[:state].present? && params[:name].present? # state, name
      markets = markets.where(state: params[:state], name: params[:name])
      render json: MarketSerializer.all_markets(markets)
    elsif params[:name].present? && !params[:city].present? # name
      markets = markets.where(name: params[:name])
      render json: MarketSerializer.all_markets(markets)
    else
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
end