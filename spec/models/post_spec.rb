# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  context '.create!' do
    subject { described_class.create!(params) }

    let(:params) do
      {
        title: title,
        text: text,
        ip_address: ip_address,
        user_id: user_id
      }
    end
    let(:title) { 'title' }
    let(:text) { 'text' }
    let(:ip_address) { 'ip_address' }
    let(:user_id) { create(:user).id }

    describe 'result' do
      it { is_expected.to be_a(described_class) }
    end

    describe 'when text is nil' do
      let(:text) { nil }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when text is not specified' do
      let(:params) { { user_id: user_id } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when user_id is nil' do
      let(:user_id) { nil }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id is not specified' do
      let(:params) { { text: text } }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'instance of the model' do
    subject { create(:post) }

    describe 'check_methods' do
      let(:methods) do
        %i[
          id
          title
          text
          ip_address
          ratings
          user
          user_id
          created_at
          updated_at
        ]
      end

      it { is_expected.to respond_to(*methods) }
    end

    describe '#id' do
      it { expect(subject.id).to be_an(Integer) }
    end

    describe '#title' do
      it { expect(subject.title).to be_a(String) }
    end

    describe '#text' do
      it { expect(subject.text).to be_a(String) }
    end

    describe '#ip_address' do
      it { expect(subject.ip_address).to be_an(IPAddr) }
    end

    describe '#user' do
      it { expect(subject.user).to be_an(User) }
    end

    describe '#user_id' do
      it { expect(subject.user_id).to be_an(Integer) }
    end

    describe '#ratings' do
      it do
        expect(subject.ratings)
          .to be_an(ActiveRecord::Associations::CollectionProxy)
      end
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

    let(:instance) { create(:post, text: 'text', user_id: user.id) }
    let(:user) { create(:user) }

    describe 'result' do
      let(:params) do
        { id: 1, text: 'another_text', user: create(:user) }
      end

      it { expect { subject }.to(change { instance.attributes }) }
    end

    describe 'when text is nil' do
      let(:params) { { text: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when user_id is nil' do
      let(:params) { { user_id: nil } }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when user_id isn\'t present in table users' do
      let(:params) { { user_id: -1 } }

      it 'should raise ActiveRecord::RecordInvalid' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when created_at is nil' do
      let(:params) { { created_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when updated_at is nil' do
      let(:params) { { updated_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end
end
