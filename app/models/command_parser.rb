# frozen_string_literal: true

class CommandParser
  include ActiveModel::Model
  include ActiveModel::Attributes

  class ParseError < StandardError; end

  RESERVED_COMMANDS = %w[entry my list all shuffle reset remove delimit]

  attribute :command
  attribute :argument

  validates :command, presence: true
  validate :validate_inclusion_of_reserved_commands, if: -> { command.present? }
  validate :validate_having_arg, if: -> { command.present? }

  def self.parse(text)
    txt = text&.strip
    pos = txt&.index(/\s+/).to_i
    raise ParseError, "Invalid text: #{text}" if txt.blank?

    cmd = txt[0..(pos - 1)]
    arg = txt[pos..-1].strip
    arg = nil if arg == cmd
    parser = new(command: cmd, argument: arg)

    raise ParseError, "Invalid command: #{cmd}, argument: #{arg}" if parser.invalid?

    parser
  end

  private

  def validate_inclusion_of_reserved_commands
    return if RESERVED_COMMANDS.include?(command)

    errors.add(:command, "Invalid command: #{command}")
  end

  def validate_having_arg
    return unless command.in?(%w[entry remove])

    errors.add(:argument, "command: #{command} needs argument") if argument.blank?
  end
end
