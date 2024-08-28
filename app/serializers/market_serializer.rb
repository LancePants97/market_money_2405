class MarketSerializer
  def self.all_markets(markets)
    {
      data: markets.map do |market|
        {
          id: market.id,
          type: 'market',
          attributes: {
            name: market.name,
            street: market.street,
            city: market.city,
            county: market.county,
            state: market.state,
            zip: market.zip,
            lat: market.lat,
            lon: market.lon,
            vendor_count: market.vendors.count
          },
          relationships: {
            vendors: {
              data: market.vendors.map do |vendor|
                {
                  id: vendor.id,
                  name: vendor.name,
                  type: 'vendor'
                }
              end
            }
          }
        }
      end
    }
  end
end