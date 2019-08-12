# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RatingsController', type: :request do
  include_context 'authenticated'

  context 'POST ratings#create' do
    let(:value) { 3.55 }
    let(:the_post) { create(:post) }
    let(:post_id) { the_post.id }

    let(:params) do
      {
        rating: {
          value: value,
          post_id: post_id
        }
      }
    end

    subject { post '/ratings', params: params }

    describe 'when all is ok' do
      before { subject }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(201) }

      it 'should contain data of new rating' do
        rating = JSON.parse(response.body, symbolize_names: true)

        expect(rating).to include(user_id: user_id, post_id: post_id)
      end

      it 'should contain exact value' do
        rating = JSON.parse(response.body, symbolize_names: true)

        expect(rating[:value].to_f).to eq(value)
      end
    end

    describe 'when value is nil' do
      before { subject }

      let(:value) { nil }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Invalid parameters passed',
          extra: {
            value: ['must be filled']
          }
        )
      end
    end

    describe 'when title isn\'t present' do
      before { subject }

      let(:params) do
        {
          rating: {
            user_id: user_id,
            post_id: post_id
          }
        }
      end

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Invalid parameters passed',
          extra: {
            value: ['is missing']
          }
        )
      end
    end

    describe 'when value isn\'t from 1 to 5' do
      before { subject }

      let(:value) { 0.999 }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Invalid parameters passed',
          extra: {
            value: ['must be 1 to 5']
          }
        )
      end
    end

    describe 'when value isn\'t float' do
      before { subject }

      let(:value) { 'isn\'t float' }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Invalid parameters passed',
          extra: {
            value: ['must be a float']
          }
        )
      end
    end

    describe 'when user_id relates to user which doesn\'t exist' do
      before { subject }

      let(:user_id) { -1 }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(401) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'User not found',
        )
      end
    end

    describe 'when post_id is nil' do
      before { subject }

      let(:post_id) { nil }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          extra: { post_id: ['must be filled'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when post_id isn\'t present' do
      before { subject }

      let(:params) do
        {
          rating: {
            value: value,
            user_id: user_id
          }
        }
      end

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          extra: { post_id: ['is missing'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when post_id relates to post which doesn\'t exist' do
      before { subject }

      let(:post_id) { -1 }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          error: 'Validation failed: Post must exist',
        )
      end
    end

    describe 'when post_id isn\'t integer' do
      before { subject }

      let(:post_id) { 'isn\'t integer' }

      it { expect(response.content_type).to eq('application/json') }
      it { expect(response.status).to eq(422) }

      it 'should contain information about error' do
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to eq(
          extra: { post_id: ['must be an integer'] },
          error: 'Invalid parameters passed',
        )
      end
    end

    describe 'when rating with same user_id and post_id exists' do
      let!(:rating) do
        create(:rating, value: start_value, user_id: user_id, post_id: post_id)
      end
      let(:start_value) { 1 }
      let(:value) { 5 }

      it 'should contain exact value' do
        expect { subject }
          .to change { Rating.find_by(user_id: user_id, post_id: post_id).value }
          .from(start_value)
          .to(value)
      end

      context 'should return correct response' do
        before { subject }

        it { expect(response.content_type).to eq('application/json') }
        it { expect(response.status).to eq(201) }

        it 'should contain updated rating' do
          post = JSON.parse(response.body, symbolize_names: true)

          expect(post).to include(user_id: user_id, post_id: post_id)
        end

        it 'should contain exact value' do
          rating = JSON.parse(response.body, symbolize_names: true)

          expect(rating[:value].to_f).to eq(value)
        end
      end
    end
  end
end
