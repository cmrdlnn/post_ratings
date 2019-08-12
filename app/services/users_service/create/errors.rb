# frozen_string_literal: true

module UsersService
  class Create < Base::Validator
    module Errors
      class UserExist < ActiveRecord::RecordNotUnique
        def initialize(login)
          super("User with login \"#{login}\" already exist")
        end
      end
    end
  end
end
