# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title      { Faker::Hipster.word                  }
    text       { Faker::Hipster.sentence              }
    ip_address { Faker::Internet.unique.ip_v4_address }
    user

    trait :with_ratings do
      transient { ratings_count { 2 } }

      after(:create) do |post, evaluator|
        create_list(:rating, evaluator.ratings_count, post: post)
      end
    end
  end
end
