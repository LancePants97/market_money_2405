class Vendor < ApplicationRecord
  has_many :market_vendors, dependent: :destroy #destroy the join table record when a vendor is deleted
  has_many :markets, through: :market_vendors

  validates_presence_of :name,
                        :description,
                        :contact_name,
                        :contact_phone

  validates :credit_accepted, inclusion: { in: [ true, false ] }
end