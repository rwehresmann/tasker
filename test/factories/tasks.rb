FactoryBot.define do
  factory :task do
    list
    name { Faker::Hipster.sentence }
    association :creator, factory: :user

    trait :complete do
      completed_at { Time.current }
      association :completer, factory: :user
    end
  end
end
