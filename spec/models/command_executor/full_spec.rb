# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Full, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'KZRB') }

    let!(:entry1) { create(:entry, user:, channel:) }
    let!(:entry2) { create(:entry, user:, channel:, status: :ordered) }
    let!(:entry3) { create(:entry, user:, channel:, status: :removed) }
    let!(:entry4) { create(:entry, user:, channel:, status: :delimited) }

    let!(:other_channel) { create(:channel, workspace:) }
    let!(:other_entry1) { create(:entry, user:, channel: other_channel) }

    let(:command) { 'full' }
    let(:argument) { '無視される' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      msg = <<~TXT
        - #{entry1.title} by #{entry1.user.name}, entryId: #{entry1.id}
        - [done] #{entry2.title} by #{entry2.user.name}, entryId: #{entry2.id}
        - [rmvd] #{entry3.title} by #{entry3.user.name}, entryId: #{entry3.id}
        - [done] #{entry4.title} by #{entry4.user.name}, entryId: #{entry4.id}
      TXT
      expect(response.message).to eq msg
      expect(response.is_private).to be true
    end
  end
end
