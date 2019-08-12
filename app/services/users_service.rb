# frozen_string_literal: true

module UsersService
  def self.create(params)
    Create.call(params)
  end
end
