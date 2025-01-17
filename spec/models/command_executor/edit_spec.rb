# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Edit, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'KZRB') }
    let!(:entry) { create(:entry, user:, channel:) }

    let(:command) { 'edit' }
    let(:argument) { "#{entry.id}  new title に更新したい" }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      msg = "KZRB の entryId: #{entry.id} のタイトルが 『new title に更新したい』 に更新されました。"
      expect(response.message).to eq msg
      expect(response.is_private).to be false
    end

    context 'when argument is wrong' do
      let(:error_message) { "ID とタイトルを指定してください /kzlt edit <entryId> title" }

      context 'when argument is blank' do
        let(:argument) { '' }

        it do
          response = subject

          expect(response.message).to eq error_message
          expect(response.is_private).to be true
        end
      end

      context 'when argument is only id' do
        let(:argument) { '12345' }

        it do
          response = subject

          expect(response.message).to eq error_message
          expect(response.is_private).to be true
        end
      end

      context 'when entryId in argument is not a number' do
        let(:argument) { 'あいう えお' }

        it do
          response = subject

          expect(response.message).to eq error_message
          expect(response.is_private).to be true
        end
      end
    end

    context 'when updater is not talker' do
      let(:other_user) { create(:user, name: 'other talker') }
      let!(:entry) { create(:entry, user: other_user, channel:) }

      it do
        response = subject

        expect(response.message).to eq 'entry が自身のものではありません。 KZRB'
        expect(response.is_private).to be true
      end
    end

    context "when entry's status is not unordered or ordered" do
      let!(:entry) { create(:entry, user:, channel:, status: :removed) }
      let(:error_message) { "ID とタイトルを指定してください /kzlt edit <entryId> title" }

      it do
        response = subject

        expect(response.message).to eq error_message
        expect(response.is_private).to be true
      end
    end
  end
end
