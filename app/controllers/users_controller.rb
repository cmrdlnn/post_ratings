# frozen_string_literal: true

class UsersController < ApplicationController
  # POST /users
  def create
    token = UsersService.create(create_params)
    render json: { token: token }, status: :created
  end

  private

  def create_params
    params.require(:user).permit(:login)
  end
end
