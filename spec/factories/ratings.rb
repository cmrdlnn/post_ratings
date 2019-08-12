# frozen_string_literal: true

FactoryBot.define do
  factory :rating, class: 'Rating' do
    value { rand * (5 - 1) + 1 }
    user
    post
  end
end
