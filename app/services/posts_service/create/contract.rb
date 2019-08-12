# frozen_string_literal: true

module PostsService
  class Create < Base::Validator
    class Contract < Dry::Validation::Contract
      params do
        required(:title).filled(:string)
        required(:text).filled(:string)
        optional(:ip_address).filled(:string)
        required(:user_id).filled(:integer)
      end
    end
  end
end
