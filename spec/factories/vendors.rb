FactoryBot.define do
  factory :vendor do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    description { Faker::Lorem.sentence }
    contact_name {Faker::Name.first_name}
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end