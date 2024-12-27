# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandParser, type: :model do
  describe '.parse' do
    subject { described_class.parse(text) }

    context 'when parsing text is blank' do
      let(:text) { '' }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when parsing text is nil' do
      let(:text) { nil }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when parsing text include only b' do
      let(:text) { " \t      " }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when command is not in text' do
      let(:text) { 'aaaaaaaaaaaa' }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when command is not in reserved list' do
      let(:text) { 'hoge foo' }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when "entry" command has no arg' do
      let(:text) { ' entry ' }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when "remove" command has no arg' do
      let(:text) { 'remove' }

      it { expect { subject }.to raise_error(CommandParser::ParseError) }
    end

    context 'when text has command and argument' do
      let(:text) { 'entry    foo bar' }

      it { expect(subject).to have_attributes(command: 'entry', argument: 'foo bar') }
    end

    context 'when command is "my"' do
      let(:text) { 'my' }

      it { expect(subject).to have_attributes(command: 'my', argument: nil) }
    end

    context 'when command is "list"' do
      let(:text) { 'list' }

      it { expect(subject).to have_attributes(command: 'list', argument: nil) }
    end

    context 'when command is "all"' do
      let(:text) { 'all' }

      it { expect(subject).to have_attributes(command: 'all', argument: nil) }
    end

    context 'when command is "shuffle"' do
      let(:text) { 'shuffle' }

      it { expect(subject).to have_attributes(command: 'shuffle', argument: nil) }
    end

    context 'when command is "reset"' do
      let(:text) { 'reset' }

      it { expect(subject).to have_attributes(command: 'reset', argument: nil) }
    end

    context 'when command is "delimit"' do
      let(:text) { 'delimit' }

      it { expect(subject).to have_attributes(command: 'delimit', argument: nil) }
    end
  end
end
