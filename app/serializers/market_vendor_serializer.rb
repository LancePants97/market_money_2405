class MarketVendorSerializer
  def self.all_market_vendors(vendors)
    {
      data: vendors.map do |vendor|
        {
          id: vendor.id,
          type: 'market vendor',
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
                  id: market.id,
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
end