# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  include_context 'authenticated'

  context 'POST posts#create' do
    let(:title) { 'title' }
    let(:text) { 'text' }

    let(:params) do
      {
        post: {
          title: title,
          text: text
        }
      }
    end

    subject { post '/posts', params: params }

    describe 'when all is ok' do
      before { subject }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(201) }

      it 'should contain data of new post' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to include(title: title, text: text, user_id: user_id)
      end
    end

    describe 'when title is nil' do
      before { subject }

      let(:title) { nil }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to eq(
          extra: { title: ['must be filled'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when title isn\'t present' do
      before { subject }

      let(:params) do
        {
          post: {
            text: text,
            user_id: user_id
          }
        }
      end

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to eq(
          extra: { title: ['is missing'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when text is nil' do
      before { subject }

      let(:text) { nil }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain token with id of new user' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to eq(
          extra: { text: ['must be filled'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when text isn\'t present' do
      before { subject }

      let(:params) do
        {
          post: {
            title: title,
            user_id: user_id
          }
        }
      end

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to eq(
          extra: { text: ['is missing'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when user_id relates to user which doesn\'t exist' do
      before { subject }

      let(:user_id) { -1 }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(401) }

      it 'should contain information about error' do
        post = JSON.parse(response.body, symbolize_names: true)
        expect(post).to eq(
          error: 'User not found',
        )
      end
    end
  end

  context 'GET posts#duplicated_ips' do
    subject { get '/posts/duplicated_ips' }

    let(:ips) { 7.times.map { Faker::Internet.unique.ip_v4_address } }
    let!(:posts) do
      items = create_list(:post, 3)
      ips.each_with_index do |ip, i|
        items.concat(
          create_list(:post, i + 2, ip_address: ip)
        )
      end
      items
    end

    before { subject }

    it { expect(response.content_type).to eq('application/json') }
    it { expect(response.status).to eq(200) }

    it 'should contain an array of 7 elements' do
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:count]).to eq(ips.size)
    end
  end
end
