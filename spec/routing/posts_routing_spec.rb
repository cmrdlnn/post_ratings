# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #duplicated_ips' do
      expect(:get => '/posts/duplicated_ips')
        .to route_to('posts#duplicated_ips')
    end

    it 'routes to #create' do
      expect(:post => '/posts').to route_to('posts#create')
    end
  end
end
