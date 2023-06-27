FactoryBot.define do
  factory :invitation do
    user { create(:user) }
    flat { create(:flat, user: create(:user)) }
    level { Faker::Number.between(from: 0, to: 1) }
  end

  factory :vote do
    user { create(:user) }
    option { create(:option, item: create(:item, room: create(:room, flat: create(:flat, user: create(:user))))) }
    stars { Faker::Number.between(from: 1, to: 5) }
  end

  factory :option do
    name { Faker::Name.name }
    size { Faker::Number.between(from: 20, to: 200) }
    description { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    price { Faker::Number.decimal(l_digits: 2) }
    item { create(:item, room: create(:room, flat: create(:flat, user: create(:user)))) }
  end

  factory :item do
    name { Faker::Name.name }
    importance { Faker::Number.between(from: 0, to: 3) }
    room { create(:room, flat: create(:flat, user: create(:user))) }
  end

  factory :room do
    name { nil } # should be set after_create with set_name callback
    kind { Faker::Number.between(from: 0, to: 5) }
    flat { create(:flat, user: create(:user)) }
  end

  factory :flat do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    budget { Faker::Number.number(digits: 5) }
    user { create(:user) }
  end

  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    nickname { Faker::Name.name }
  end
end
