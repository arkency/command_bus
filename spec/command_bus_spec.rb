require 'spec_helper'
require 'arkency/command_bus'

module Arkency
  class TestHandler
    def call(command); end
  end

  RSpec.describe CommandBus do
    ::FooCommand = Class.new

    specify do
      bus = CommandBus.new
      command_handler =
        double(:handler, call: nil)
      bus.register(::FooCommand, command_handler)
      bus.(command = ::FooCommand.new)

      expect(command_handler)
        .to(have_received(:call).with(command))
    end

    specify 'no handler' do
      bus = CommandBus.new
      expect{ bus.(command = ::FooCommand.new) }
        .to(raise_error(CommandBus::UnregisteredHandler) { |err|
          expect(err.message)
            .to(eq('Missing handler for FooCommand')) })
    end

    specify 'one command, one handler' do
      bus = CommandBus.new
      bus.register(::FooCommand, ->{})
      expect{bus.register(::FooCommand, ->{})}
        .to(raise_error(CommandBus::MultipleHandlers) { |err|
          expect(err.message)
            .to(eq('Multiple handlers not allowed for FooCommand')) })
    end

    specify 'class handler is instantiated per call' do
      handler = instance_double(TestHandler)
      command = ::FooCommand.new

      bus = CommandBus.new
      bus.register(::FooCommand, TestHandler)

      allow(TestHandler).to receive(:new).and_return(handler)
      allow(handler).to receive(:call).and_return(command)

      expect(bus.call(command)).to eq command

      expect(TestHandler).to have_received(:new)
      expect(handler).to have_received(:call).with(command)
    end
  end
end
