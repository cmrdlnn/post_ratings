# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :auth!, only: %i[create]

  # POST /posts
  def create
    post = PostsService.create(
      create_params,
      ip_address: request.remote_ip,
      user_id:    user.id
    )
    render json: post, status: :created
  end

  # GET /posts/duplicated_ips
  def duplicated_ips
    ips = PostsService.duplicated_ips
    render json: ips.as_json(only: [:count])
  end

  private

  def create_params
    params.require(:post).permit(:title, :text)
  end
end
