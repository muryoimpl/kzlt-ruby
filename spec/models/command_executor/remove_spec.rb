# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Remove, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'KZRB') }
    let!(:entry) { create(:entry, user:, channel:) }

    let(:command) { 'remove' }
    let(:argument) { "#{entry.id}" }

    it do
      expect { subject }.to change(Entry, :count).by(-1)
    end

    it do
      response = subject

      msg = "LT title: #{entry.title} のエントリが取り消されました。"
      expect(response.message).to eq msg
    end

    context "when will remove other user's entry" do
      let!(:other_user) { create(:user) }
      let!(:other_entry) { create(:entry, user: other_user, channel:) }
      let(:argument) { "#{other_entry.id}" }

      it do
        expect { subject }.not_to change(Entry, :count)
      end

      it do
        response = subject

        msg = "entry が自身のものではありません。 #{user.name}"
        expect(response.message).to eq msg
      end
    end

    context "when can't find entry by id" do
      let(:argument) { "999999999" }

      it do
        response = subject

        msg = "entry 時に返ってきた entryId を指定してください /kzlt remove 1"
        expect(response.message).to eq msg
      end
    end
  end
end
