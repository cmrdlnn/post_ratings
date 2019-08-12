# frozen_string_literal: true

module RatingsService
  class Create < Base::Validator
    def call
      rating = Rating.find_by(native_primary_key)
      return Rating.create!(params) unless rating
      rating.update(value)
      rating
    end

    private

    def native_primary_key
      params.slice(:user_id, :post_id)
    end

    def value
      params.slice(:value)
    end
  end
end
