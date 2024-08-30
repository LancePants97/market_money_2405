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

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
        render json: vendor, status: 201
    else
      render json: {
        errors: [
          {
            status: '400',
            detail: "Couldn't create Vendor without all attributes"
          }
        ]
    }, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: vendor, status: 200
    else
      render json: {
        errors: [
          {
            status: '400',
            detail: "Couldn't update Vendor with empty attribute"
          }
        ]
    }, status: :bad_request
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
    render json:{}, status: :no_content
  rescue ActiveRecord::RecordNotFound => exception
    render json: { errors: [ { status: '404', detail: exception.message } ] }, status: :not_found
  end

  private
  def vendor_params
    params.require(:vendor).permit(:name, 
                                  :description, 
                                  :contact_name, 
                                  :contact_phone, 
                                  :credit_accepted)
  end
end