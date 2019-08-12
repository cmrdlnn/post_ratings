# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes #create' do
      expect(:post => '/users').to route_to('users#create')
    end
  end
end
