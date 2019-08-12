# frozen_string_literal: true

module UsersService
  class Create
    class Contract < Dry::Validation::Contract
      params do
        required(:login).filled(:string)
      end
    end
  end
end
