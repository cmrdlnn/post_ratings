# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  context '.create!' do
    subject { described_class.create!(params) }

    let(:params) { { login: 'user' } }
    let(:post) { create(:post) }

    describe 'result' do
      it { is_expected.to be_a(described_class) }
    end

    describe 'when login is not specified' do
      let(:params) { {} }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when login is nil' do
      let(:params) { { login: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when a user with the same login already exists' do
      before { create(:user, login: params[:login]) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  context 'instance of the model' do
    subject { create(:user) }

    describe 'check_methods' do
      let(:methods) { %i[id login posts] }

      it { is_expected.to respond_to(*methods) }
    end

    describe '#id' do
      it { expect(subject.id).to be_an(Integer) }
    end

    describe '#login' do
      it { expect(subject.login).to be_a(String) }
    end

    describe '#post' do
      it do
        expect(subject.posts)
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

    let!(:instance) { create(:user, login: 'user') }

    describe 'result' do
      let(:params) { { id: 1, login: 'another_user' } }

      it { expect { subject }.to(change { instance.attributes }) }
    end

    describe 'when login is nil' do
      let(:params) { { login: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    describe 'when a user with the same login already exists' do
      let(:params) { { login: 'another_user' } }

      before { create(:user, login: params[:login]) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    describe 'when created_at is nil' do
      let(:params) { { created_at: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
  end
end
