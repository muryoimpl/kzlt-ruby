# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Entry, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'KZRB') }

    let(:command) { 'entry' }
    let(:argument) { 'Lightning Talk のタイトル' }

    it do
      expect { subject }.to change(Entry, :count).from(0).to(1)
    end

    it do
      response = subject

      entry = channel.entries.first
      expect(response.message).to eq "KZRB さんから LT:「#{argument}」のエントリがありました。entryId: #{entry.id}"
    end
  end
end
