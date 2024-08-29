require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'associations' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    it "vendors_count" do
      market1 = FactoryBot.create(:market)
      market2 = FactoryBot.create(:market)
  
      vendor1 = FactoryBot.create(:vendor)
      vendor2 = FactoryBot.create(:vendor)
      vendor3 = FactoryBot.create(:vendor)
  
      MarketVendor.create(market: market1, vendor: vendor1)
      MarketVendor.create(market: market1, vendor: vendor2)
      MarketVendor.create(market: market2, vendor: vendor3)

      expect(market1.vendors_count).to eq(2)
      expect(market2.vendors_count).to eq(1)
    end
  end
end