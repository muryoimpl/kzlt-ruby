# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandExecutor::Tutorial, type: :model do
  describe '#execute' do
    subject { described_class.new(command:, argument:, channel:, user:).execute }

    let(:workspace) { create(:workspace) }
    let(:channel) { create(:channel, workspace:) }
    let(:user) { create(:user) }

    let(:command) { 'tutorial' }
    let(:argument) { ' 無視される ' }

    it do
      expect { subject }.not_to change(Entry, :count)
    end

    it do
      response = subject

      expect(response.message).to eq described_class::MESSAGE
    end
  end
end
