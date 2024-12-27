# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/entries', type: :request do
  subject do
    post('/api/entries', headers:, params:)
    response.body
  end

  let(:headers) do
    { 'Content-Type' => 'application/x-www-form-urlencoded' }
  end
  let(:workspace) { create(:workspace) }
  let(:token) { workspace.token }
  let(:command) { '/kzlt' }
  let(:params) do
    {
      token:,
      team_id: 'baf05f22bb869c0c8f9568c8648e474a',
      team_domain: 'kzrb',
      enterprise_id: 'E0001',
      enterprise_name: 'Globular%20Construct%20Inc',
      channel_id: 'C2147483705',
      channel_name: 'test',
      user_id: 'U2147483697',
      user_name: 'Steve',
      command:,
      text: 'entry あいうえお',
      response_url: 'https://hooks.slack.com/commands/1234/5678',
      trigger_id: '13345224609.738474920.8088930838d88f008e0',
      api_app_id: 'A123456'
    }
  end

  context "when can't find workspace by token" do
    let(:token) { 'unknown-token' }

    it do
      subject

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include 'Invalid token'
    end
  end

  context 'when comand is not "/kzlt"' do
    let(:command) { '/kzlti' }

    it do
      subject

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include 'Invalid command'
    end
  end
end
