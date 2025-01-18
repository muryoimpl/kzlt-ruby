# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::User, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user, name: 'before') }

    let(:command) { 'user' }
    let(:argument) { 'after' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      expect { subject }.to change { user.reload.name }.from('before').to('after')
    end

    it do
      response = subject

      expect(response.message).to eq "name を「before」から「after」に変更しました。"
      expect(response.is_private).to be true
    end
  end
end
