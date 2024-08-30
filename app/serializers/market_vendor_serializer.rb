class MarketVendorSerializer
  def self.all_market_vendors(vendors)
    {
      data: vendors.map do |vendor|
        {
          id: vendor.id.to_s,
          type: 'vendor',
          attributes: {
            name: vendor.name,
            description: vendor.description,
            contact_name: vendor.contact_name,
            contact_phone: vendor.contact_phone,
            credit_accepted: vendor.credit_accepted
          },
          relationships: {
            markets: {
              data: vendor.markets.map do |market|
                {
                  id: market.id.to_s,
                  name: market.name,
                  type: 'market'
                }
              end
            }
          }
        }
      end
    }
  end

  def self.new_market_vendor(market_vendor)
    {
      data: {
        id: market_vendor.id.to_s,
        type: 'market_vendor',
        attributes: {
          market_id: market_vendor.market_id,
          vendor_id: market_vendor.vendor_id
        },
        message: "Successfully added vendor to market"
      }
    }
  end
end