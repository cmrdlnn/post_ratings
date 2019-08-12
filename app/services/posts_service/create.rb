# frozen_string_literal: true

module PostsService
  class Create < Base::Validator
    def call
      Post.create!(params).tap do |post|
        post.ip_address = post.ip_address.to_s
      end
    end
  end
end
