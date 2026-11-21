# frozen_string_literal: true

require "puma/plugin"

# Copy of the litestream gem's Puma plugin (lib/puma/plugin/litestream.rb, 0.15.0 and 0.16.1) using the
# event hooks that replace the ones deprecated in Puma 8 and removed in Puma 9.
# Switch back to `plugin :litestream` once the gem uses after_booted / after_stopped / before_restart.
Puma::Plugin.create do
  attr_reader :litestream_pid, :log_writer

  def start(launcher)
    @log_writer = launcher.log_writer

    launcher.events.after_booted do
      @litestream_pid = Litestream::Commands.replicate(async: true)

      in_background do
        monitor_litestream
      end
    end

    launcher.events.after_stopped { stop_litestream }
    launcher.events.before_restart { stop_litestream }
  end

  private

  def stop_litestream
    Process.waitpid(litestream_pid, Process::WNOHANG)
    log_writer.log "Stopping Litestream..."
    Process.kill(:INT, litestream_pid) if litestream_pid
    Process.wait(litestream_pid)
  rescue Errno::ECHILD, Errno::ESRCH
    nil
  end

  def monitor_litestream
    monitor(:litestream_dead?, "Detected Litestream has gone away, stopping Puma...")
  end

  def monitor(process_dead, message)
    loop do
      if send(process_dead)
        log message
        Process.kill(:INT, $$)
        break
      end
      sleep 2
    end
  end

  def litestream_dead?
    Process.waitpid(litestream_pid, Process::WNOHANG)
    false
  rescue Errno::ECHILD, Errno::ESRCH
    true
  end

  def log(...)
    log_writer.log(...)
  end
end
