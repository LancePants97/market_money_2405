class Api::V0::MarketVendorsController < ApplicationController
  def index
    begin
      market = Market.find(params[:market_id])
      vendors = market.vendors
      render json: MarketVendorSerializer.all_market_vendors(vendors)
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