# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  context 'POST users#create' do
    let(:login) { 'login' }

    let(:params) do
      {
        user: {
          login: login
        }
      }
    end

    subject { post '/users', params: params }

    describe 'when all is ok' do
      before { subject }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(201) }

      it 'should contain token with id of new user' do
        token   = JSON.parse(response.body)['token']
        payload = JSONWebToken.decode(token).first
        user_id = payload['id']
        user    = User.find(user_id)
        expect(user.login).to eq(login)
      end
    end

    describe 'when login is nil' do
      before { subject }

      let(:login) { nil }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Invalid parameters passed',
          extra: {
            login: ['must be filled']
          }
        )
      end
    end

    describe 'when params are empty' do
      before { subject }

      let(:params) { {} }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'param is missing or the value is empty: user'
        )
      end
    end

    describe 'when user with same login is already exist' do
      before do
        create(:user, login: login)
        subject
      end

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(409) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: "User with login \"#{login}\" already exist"
        )
      end
    end
  end
end
