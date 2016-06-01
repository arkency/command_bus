require 'spec_helper'
require 'arkency/command_bus'

module Arkency
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
  end
end
