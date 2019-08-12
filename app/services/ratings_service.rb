# frozen_string_literal: true

module RatingsService
  def self.create(params, rest)
    Create.call(params, rest)
  end
end
