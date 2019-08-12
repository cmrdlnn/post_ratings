# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  context 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  context '.create!' do
    subject { described_class.create!(params) }

    let(:params) { { value: value, user_id: user_id, post_id: post_id } }

    let(:value) { 5 }
    let(:post) { create(:post) }
    let(:post_id) { post.id }
    let(:user) { create(:user) }
    let(:user_id) { user.id }

    it 'should create new rating' do
      subject
      expect(Rating.first)
        .to have_attributes(value: value, user_id: user_id, post_id: post_id)
    end

    describe 'when value isn\'t integer' do
      let(:value) { 4.99 }

      it 'should update field average_rating for post' do
        subject
        expect(Rating.first.value).to eq(4.99)
      end
    end

    describe 'when value goes beyond the interval 1..5' do
      let(:value) { 6 }

      it 'should raise ActiveRecord::StatementInvalid' do
        expect { subject }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end

    describe 'when value is not specified' do
      let(:params) { { user_id: user_id, post_id: post.id } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when value is nil' do
      let(:value) { nil }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when post_id is not present in table posts' do
      let(:post_id) { -1 }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when post_id is nil' do
      let(:post_id) { nil }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is not specified' do
      let(:params) { { value: value, user_id: user_id } }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is not present in table users' do
      let(:user_id) { -1 }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is nil' do
      let(:user_id) { nil }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is not specified' do
      let(:params) { { value: value, post_id: post_id } }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'instance of the model' do
    subject { create(:rating) }

    describe 'check_methods' do
      let(:methods) { %i[id value post post_id created_at updated_at] }

      it { is_expected.to respond_to(*methods) }
    end

    describe '#id' do
      it { expect(subject.id).to be_an(Integer) }
    end

    describe '#value' do
      it { expect(subject.value).to be_an(BigDecimal) }
    end

    describe '#post' do
      it { expect(subject.post).to be_a(Post) }
    end

    describe '#post_id' do
      it { expect(subject.post_id).to be_an(Integer) }
    end

    describe '#user' do
      it { expect(subject.user).to be_an(User) }
    end

    describe '#user_id' do
      it { expect(subject.user_id).to be_an(Integer) }
    end

    describe '#created_at' do
      it { expect(subject.created_at).to be_a(Time) }
    end

    describe '#updated_at' do
      it { expect(subject.updated_at).to be_a(Time) }
    end
  end

  context '#update!' do
    subject { instance.update!(params) }

    let!(:instance) { create(:rating, value: initial_value) }

    let(:params) do
      {
        id: instance.id,
        value: value,
        user_id: user_id,
        post_id: post_id
      }
    end

    let(:initial_value) { 1 }
    let(:value) { 5 }
    let(:post) { create(:post) }
    let(:post_id) { post.id }
    let(:user) { create(:user) }
    let(:user_id) { user.id }

    it 'should change value' do
      expect { subject }
        .to change { Rating.first.reload.value }
        .from(initial_value)
        .to(value)
    end

    it 'should change user_id' do
      expect { subject }
        .to change { Rating.first.reload.user_id }
        .from(instance.user_id)
        .to(user_id)
    end

    it 'should change post_id' do
      expect { subject }
        .to change { Rating.first.reload.post_id }
        .from(instance.post_id)
        .to(post_id)
    end

    describe 'when value goes beyond the integer interval 1..5' do
      let(:value) { 6 }

      it 'should raise ActiveRecord::StatementInvalid' do
        expect { subject }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end

    describe 'when value is nil' do
      let(:value) { nil }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when post_id is nil' do
      let(:post_id) { nil }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when post_id is not present in table posts' do
      let(:post_id) { -1 }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is nil' do
      let(:user_id) { nil }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is not present in table users' do
      let(:user_id) { -1 }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when created_at is nil' do
      let(:params) { { id: instance.id, created_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when updated_at is nil' do
      let(:params) { { id: instance.id, updated_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when updated_at is nil' do
      let(:params) { { id: instance.id, updated_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when rating with same user_id and post_id exists' do
      before { create(:rating, user_id: user_id, post_id: post_id) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
