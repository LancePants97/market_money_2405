class Api::V0::VendorsController < ApplicationController
  def show
    begin
      render json: VendorSerializer.show_vendor(Vendor.find(params[:id]))
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