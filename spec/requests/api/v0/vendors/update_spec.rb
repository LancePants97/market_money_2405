require 'rails_helper'

RSpec.describe 'Update a Vendor', type: :request do
  it "can update an existing vendor" do
    vendor1 = FactoryBot.create(:vendor)

    previous_name = Vendor.last.name

    vendor_params = ({
                    name: 'The Muffin Man',
                    description: 'He lives on Drury Lane',
                    contact_name: 'MuffinDude420',
                    contact_phone: '555-555-5555',
                    credit_accepted: true
                  })

    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v0/vendors/#{vendor1.id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    updated_vendor = Vendor.find_by(id: vendor1.id)
  
    expect(response).to be_successful
    expect(updated_vendor.name).to_not eq(previous_name)
    expect(updated_vendor.name).to eq("The Muffin Man")
  end
end