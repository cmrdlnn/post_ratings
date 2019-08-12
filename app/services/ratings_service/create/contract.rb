# frozen_string_literal: true

module RatingsService
  class Create < Base::Validator
    class Contract < Dry::Validation::Contract
      params do
        required(:value).filled(:float)
        required(:user_id).filled(:integer)
        required(:post_id).filled(:integer)
      end

      rule(:value) do
        key.failure('must be 1 to 5') if value < 1 || value > 5
      end
    end
  end
end
