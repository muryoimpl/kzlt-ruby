# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Delimit, type: :model do
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

    let(:command) { 'delimit' }
    let(:argument) { '無視される' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      expect { subject }.to change { entry1.reload.status }.to('delimited').and \
        change { entry2.reload.status }.to('delimited').and \
        not_change { entry3.reload.status }.from('removed').and \
        not_change { entry4.reload.status }.from('delimited')
    end

    it do
      response = subject

      expect(response.message).to eq 'ここまで順番を決めたエントリは発表済みとみなします'
      expect(response.is_private).to be false
    end

    context 'When there is no entry' do
      before do
        Entry.destroy_all
      end

      it do
        response = subject

        expect(response.message).to eq 'ここまで順番を決めたエントリは発表済みとみなします'
        expect(response.is_private).to be false
      end
    end
  end
end
