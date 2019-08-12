# frozen_string_literal: true

ips_count = 100
posts_count_per_ip_min = 5
posts_count_per_ip_max = 100
users_count = 50
ratings_count = 1000

posts_count_options = (posts_count_per_ip_min..posts_count_per_ip_max).to_a

users = FactoryBot.create_list(:user, users_count)
ips   = ips_count.times.map { Faker::Internet.unique.ip_v4_address }
posts = ips.each_with_object([]) do |ip, memo|
  memo.concat(
    FactoryBot.create_list(
      :post,
      posts_count_options.sample,
      ip_address: ip,
      user: users.sample
    )
  )
end
ratings = ratings_count.times.map do
  begin
    FactoryBot.create(:rating, user: users.sample, post: posts.sample)
  rescue
  end
end
