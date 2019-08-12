# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    login { Faker::Internet.unique.username }

    trait :with_posts do
      transient { count { 2 } }

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.count, user: user)
      end
    end

    trait :with_posts_with_the_same_ip_address do
      transient do
        count { 2 }
        ip { Faker::Internet.unique.ip_v4_address }
      end

      after(:create) do |user, evaluator|
        create_list(
          :post,
          evaluator.count,
          user: user,
          ip_address: evaluator.ip
        )
      end
    end
  end
end
