# frozen_string_literal: true

class CommandExecutor
  class Shuffle < Executor
    BREAK_PACE = 4

    attr_reader :fixed_seed

    def execute
      @delimited = channel.entries.delimited
      entries = channel.entries.unordered.eager_load(:user)

      if entries.blank?
        return CommandExecutor::Response.new(message: no_entry_message,
                                             is_private: true)
      end

      @shuffled = entries.to_a.shuffle(random:)
      @fixed_seed = random.seed

      ::Entry.where(id: entries.map(&:id)).update_all(status: :ordered)
      CommandExecutor::Response.new(message:)
    end

    private

    def message
      text_array = []
      mkdn_array = []
      break_index = @delimited.size % BREAK_PACE

      # | タイトル | 時刻	 | 時間	 | 担当 |
      @shuffled.each do |entry|
        break_index += 1

        text_array << "- #{entry.title} by #{entry.user.name}"
        mkdn_array << "| #{entry.title} | | | #{entry.user.name} |"

        if (break_index % BREAK_PACE).zero?
          text_array << "- 【休憩】"
          mkdn_array << "| 休憩 | | | |"
        end
      end

      <<~MSG
        total entries: #{@delimited.size + @shuffled.size} 件
        shuffled entries: #{@shuffled.size} 件

        #{text_array.join("\n")}

        ```
        #{mkdn_array.join("\n")}
        ```
        seed: #{@fixed_seed}
      MSG
    end

    def random
      arg_seed = argument.to_i
      arg_seed.zero? ? Random.new : Random.new(arg_seed)
    end
  end
end
