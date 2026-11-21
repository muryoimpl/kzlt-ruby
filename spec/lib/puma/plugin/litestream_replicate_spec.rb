# frozen_string_literal: true

require "rails_helper"
require "puma/events"
require "puma/plugin"

RSpec.describe "Puma plugin litestream_replicate" do
  let(:plugin) do
    require Rails.root.join("lib/puma/plugin/litestream_replicate").to_s
    Puma::Plugins.find("litestream_replicate").new
  end
  let(:events) { Puma::Events.new }
  let(:launcher) { instance_double(Puma::Launcher, events: events, log_writer: instance_double(Puma::LogWriter)) }

  it "registers its hooks without deprecated Puma event methods" do
    allow(Puma).to receive(:deprecate_method_change)

    plugin.start(launcher)

    expect(Puma).not_to have_received(:deprecate_method_change)
  end

  it "starts Litestream replication after Puma boots" do
    allow(Litestream::Commands).to receive(:replicate).and_return(12_345)
    allow(plugin).to receive(:in_background)
    plugin.start(launcher)

    events.fire_after_booted!

    expect(Litestream::Commands).to have_received(:replicate).with(async: true)
  end
end
