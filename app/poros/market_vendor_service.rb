class MarketVendorService
  def initialize(params)
    @market_id = params[:market_id]
    @vendor_id = params[:vendor_id]
  end

  def add_vendor_to_market
    return { status: :bad_request, json: { errors: [{ status: '400', detail: 'Market ID and Vendor ID must be provided' }] } } if @market_id.blank? || @vendor_id.blank?
    
    market = Market.find_by(id: @market_id)
    vendor = Vendor.find_by(id: @vendor_id)
    
    if market.nil? 
      return { status: :not_found, json: { errors: [{ status: '404', detail: 'Market not found' }] } }
    elsif vendor.nil? 
      return { status: :not_found, json: { errors: [{ status: '404', detail: 'Vendor not found' }] } }
    end

    market_vendor = MarketVendor.find_by(market_id: @market_id, vendor_id: @vendor_id)
    if market_vendor
      return { status: :unprocessable_entity, json: { errors: [{ status: '422', detail: "Validation failed: Market vendor association between market with market_id=#{@market_id} and vendor_id=#{@vendor_id} already exists" }] } }
    end

    market_vendor = MarketVendor.new(market_id: @market_id, vendor_id: @vendor_id)
    if market_vendor.save
      return { status: :created, json: MarketVendorSerializer.new_market_vendor(market_vendor) }
    else
      return { status: :unprocessable_entity, json: { errors: [{ status: '422', detail: 'Failed to create market vendor association' }] } }
    end
  end
end