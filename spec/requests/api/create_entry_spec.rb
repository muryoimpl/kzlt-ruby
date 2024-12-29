# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/entries', type: :request do
  subject do
    post('/api/entries', headers:, params:)
    response.body
  end

  let!(:workspace) { create(:workspace, slack_team_id: 'baf05f22bb869c0c8f9568c8648e474a') }
  let(:slack_team_id) { workspace.slack_team_id }
  let(:command) { '/kzlt' }
  let(:text) { 'entry foo' }
  let(:user_id) { 'C2147483705' }
  let(:params) do
    {
      token: SecureRandom.hex,
      team_id: slack_team_id,
      team_domain: 'kzrb',
      enterprise_id: 'E0001',
      #       enterprise_name: 'Globular Construct Inc',
      enterprise_name: 'GlobularConstructInc',
      channel_id: 'C2147483705',
      channel_name: 'test',
      user_id:,
      user_name: 'Steve',
      command:,
      text:,
      response_url: 'https://hooks.slack.com/commands/1234/5678',
      trigger_id: '13345224609.738474920.8088930838d88f008e0',
      api_app_id: 'A123456'
    }
  end

  let(:headers) do
    {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'X-Slack-Request-Timestamp' => signatured_at,
      'X-Slack-Signature' => hmac_digest(params)
    }
  end

  before do
    stub_const(
      "ENV",
      ENV.to_hash.merge("APP_SLACK_SIGNING_SECRET" => SecureRandom.hex)
    )
    # CommandExecutor::Executor 子クラス をロードする必要があるため呼び出す
    CommandExecutor::Entry
  end

  context "when can't find workspace by slack_team_id" do
    let(:slack_team_id) { 'unknown-team_id' }

    it do
      subject

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include 'Invalid team_id'
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

  context 'when text is invalid' do
    let(:text) { 'hoge' }

    it do
      subject

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq Help::TEXT
    end
  end

  context 'when text is blank' do
    let(:text) { '' }

    it do
      subject

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq Help::TEXT
    end
  end

  context 'when failed to create data' do
    let(:user_id) { nil }

    it do
      subject

      expect(response.body).to include 'user_idを入力してください'
    end
  end

  context 'when all parameter is valid' do
    context 'when the first request for channel, user and entry' do
      let(:text) { 'entry test' }

      it do
        expect { subject }.to change(Channel, :count).by(1).and \
          change(User, :count).by(1).and \
          change(Entry, :count).from(0).to(1)

        expected_text = "#{params[:user_name]} さんから LT:「test」のエントリがありました。entryId: #{Entry.last.id}"
        expect(response.parsed_body['text']).to eq expected_text
      end
    end
  end
end
