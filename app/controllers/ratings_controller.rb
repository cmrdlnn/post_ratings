# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :auth!

  # POST /ratings
  def create
    rating = RatingsService.create(create_params, { user_id: user.id })
    render json: rating, status: :created
  end

  private

  def create_params
    params.require(:rating).permit(:value, :post_id)
  end
end
