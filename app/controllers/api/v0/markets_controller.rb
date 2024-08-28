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
end