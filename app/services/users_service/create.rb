# frozen_string_literal: true

require Rails.root.join('lib', 'json_web_token')
require_relative 'create/errors'

module UsersService
  class Create < Base::Validator
    def call
      user = User.create(params)
      token(user.id)
    rescue ActiveRecord::RecordNotUnique
      raise Errors::UserExist, params[:login]
    end

    private

    def token(user_id)
      JSONWebToken.encode(id: user_id)
    end
  end
end
