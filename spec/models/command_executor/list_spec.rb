# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::List, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user: user1).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user1) { create(:user, name: 'm1') }
    let(:user2) { create(:user, name: 'm2') }

    let!(:entry1) { create(:entry, user: user1, channel:) }
    let!(:entry2) { create(:entry, user: user2, channel:) }
    let!(:entry3) { create(:entry, user: user1, channel:) }

    let(:command) { 'list' }
    let(:argument) { '無視される' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      msg = <<~TXT
        現在までのエントリー: 3 件
        - #{entry1.title} by #{user1.name}, entryId: #{entry1.id}
        - #{entry2.title} by #{user2.name}, entryId: #{entry2.id}
        - #{entry3.title} by #{user1.name}, entryId: #{entry3.id}
      TXT
      expect(response.message).to eq msg
    end

    context 'entry がない場合' do
      before do
        Entry.destroy_all
      end

      it do
        response = subject

        expect(response.message).to eq 'エントリーはありません'
      end
    end
  end
end
