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

  def create
    market_vendor = MarketVendorService.new(market_vendor_params)
    result = market_vendor.add_vendor_to_market
    render json: result[:json], status: result[:status]
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if market_vendor
      market_vendor.destroy
      head :no_content
    else
      render json: {
        errors: [
          {
            status: '404',
            detail: 'MarketVendor association not found'
          }
        ]
      }, status: :not_found
    end
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end