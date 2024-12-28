# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Shuffle, type: :model do
  describe '#execute' do
    let(:shuffle_instance) { described_class.new(command:, argument:, channel:, user:) }
    subject { shuffle_instance.execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'KZRB') }

    let!(:entry1) { create(:entry, user:, channel:, title: 't1') }
    let!(:entry2) { create(:entry, user:, channel:, status: :ordered, title: 't2') }
    let!(:entry3) { create(:entry, user:, channel:, status: :removed, title: 't3') }
    let!(:entry4) { create(:entry, user:, channel:, status: :delimited, title: 't4') }

    let!(:other_channel) { create(:channel, workspace:) }
    let!(:other_entry1) { create(:entry, user:, channel: other_channel) }

    let(:command) { 'shuffle' }
    let(:argument) { '無視される' }

    before do
      stub_const('CommandExecutor::Shuffle::BREAK_PACE', 1)
    end

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      expect { subject }.to change { entry1.reload.status }.from('unordered').to('ordered')
    end

    it do
      response = subject

      expect(response.message).to include <<~MSG
        - #{entry1.title} by #{entry1.user.name}
        - 【休憩】

        ```
        | #{entry1.title} | | | #{entry1.user.name} |
        | 休憩 | | | |
        ```
      MSG

      expect(response.message).to match /seed: \d+/
      expect(response.is_private).to be false
    end


    context 'エントリが複数ある場合' do
      let!(:entry5) { create(:entry, user:, channel:, title: 't5') }
      let!(:entry6) { create(:entry, user:, channel:, title: 't6') }

      before do
        fixed_entries = [ entry6, entry5, entry1 ]
        allow_any_instance_of(Array).to receive(:shuffle).and_return(fixed_entries)
      end

      it do
        expect { subject }.to change { entry1.reload.status }.from('unordered').to('ordered').and \
          change { entry5.reload.status }.from('unordered').to('ordered').and \
          change { entry6.reload.status }.from('unordered').to('ordered')
      end

      it do
        response = subject

        expect(response.message).to eq <<~MSG
          - #{entry6.title} by #{entry6.user.name}
          - 【休憩】
          - #{entry5.title} by #{entry5.user.name}
          - 【休憩】
          - #{entry1.title} by #{entry1.user.name}
          - 【休憩】

          ```
          | #{entry6.title} | | | #{entry6.user.name} |
          | 休憩 | | | |
          | #{entry5.title} | | | #{entry5.user.name} |
          | 休憩 | | | |
          | #{entry1.title} | | | #{entry1.user.name} |
          | 休憩 | | | |
          ```
          seed: #{shuffle_instance.fixed_seed}
        MSG

        expect(response.message).to match /seed: \d+/
        expect(response.is_private).to be false
      end
    end

    context '引数に seed が渡されている場合' do
      let(:argument) { '123456' }

      it do
        response = subject

        expect(response.message).to include "seed: 12345"
        expect(response.is_private).to be false
      end
    end

    context 'エントリがない場合' do
      before do
        Entry.destroy_all
      end

      it do
        response = subject

        expect(response.message).to eq 'エントリーはありません'
        expect(response.is_private).to be true
      end
    end
  end
end
