# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommandExecutor::Executor, type: :model do
  describe "#initialize" do
    subject { described_class.new(command:, argument:, channel:, user:) }

    context "when command and class name are different" do
      let(:workspace) { create(:workspace) }
      let(:command) { 'foo' }
      let(:argument) { '' }
      let(:channel) { create(:channel, workspace:) }
      let(:user) { create(:user, name: 'KZRB') }

      it do
        expect { subject }.to raise_error(CommandExecutor::CommandMismatchError)
      end
    end
  end
end
