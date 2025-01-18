# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Self, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user) }

    let(:command) { 'self' }
    let(:argument) { ' 無視される ' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      expect(response.message).to eq "username: #{user.name}"
      expect(response.is_private).to be true
    end
  end
end
