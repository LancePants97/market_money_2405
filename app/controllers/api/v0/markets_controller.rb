class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.all_markets(Market.all)
  end
end