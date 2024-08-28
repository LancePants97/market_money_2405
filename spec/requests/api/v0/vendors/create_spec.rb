require 'rails_helper'

RSpec.describe 'Create a Vendor', type: :request do
  it "can create a new vendor" do
    vendor_params = ({
                    name: 'The Muffin Man',
                    description: 'He lives on Drury Lane',
                    contact_name: 'MuffinDude420',
                    contact_phone: '555-555-5555',
                    credit_accepted: true
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last
  
    expect(response).to be_successful

    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end
end