# frozen_string_literal: true

module PostsService
  class DuplicatedIps
    def self.call
      count = Post.select('COUNT(*)')
                  .from(
                    Post.select(:ip_address)
                        .where('ip_address IS NOT NULL')
                        .group(:ip_address)
                        .having(Arel.sql('COUNT(DISTINCT user_id) > 1'))
                  )
      count[0]
    end
  end
end
