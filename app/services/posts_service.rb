# frozen_string_literal: true

module PostsService
  def self.create(params, rest)
    Create.call(params, rest)
  end

  def self.duplicated_ips
    DuplicatedIps.call
  end
end
