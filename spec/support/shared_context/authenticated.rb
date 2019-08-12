# frozen_string_literal: true

require Rails.root.join('lib', 'json_web_token')

RSpec.shared_context 'authenticated' do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:token) { JSONWebToken.encode(id: user_id) }

  before do
    allow_any_instance_of(ActionDispatch::Http::Headers)
      .to receive(:[])
      .with('Authorization')
      .and_return("Bearer #{token}")
  end
end
