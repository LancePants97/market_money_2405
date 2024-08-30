class AtmSerializer
  def self.all_atms(atms)
    {
      data: atms.map do |atm|
          id => nil
          type => "atm",
          attributes => {
            name: atm[1][1][1][:poi][:name],
            address: atm[1][1][1][:address][:streetNumber] + " " +
                      atm[1][1][1][:address][:streetName] + ", " +
                      atm[1][1][1][:address][:municipality] + ", " +
                      atm[1][1][1][:address][:countrySubdivision] + " " +
                      atm[1][1][1][:address][:postalCode]
            lat: atm[1][1][1][:position][:lat],
            lon: atm[1][1][1][:position][:lon]
          }
      end
    }
  end
end