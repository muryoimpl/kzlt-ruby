# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::My, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user) }
    let!(:entry1) { create(:entry, channel:, user:, title: '1') }
    let!(:entry2) { create(:entry, channel:, user:, title: '2') }

    let(:command) { 'my' }
    let(:argument) { ' 無視される ' }

    before do
      create(:entry, channel:, user:, status: :removed)
    end

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      expect(response.message).to eq <<~TXT
        #{user.name}のエントリー
        - #{entry1.title}, entryId: #{entry1.id}
        - #{entry2.title}, entryId: #{entry2.id}
      TXT
      expect(response.is_private).to be false
    end
  end
end
