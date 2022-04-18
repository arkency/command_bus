require 'arkency/command_bus/version'
require 'concurrent/map'

module Arkency
  class CommandBus
    UnregisteredHandler = Class.new(StandardError)
    MultipleHandlers    = Class.new(StandardError)

    def initialize
      @handlers =
        Concurrent::Map.new
    end

    def register(klass, handler)
      raise MultipleHandlers.new("Multiple handlers not allowed for #{klass}") if handlers[klass]
      handlers[klass] = handler
    end

    def call(command)
      handlers
        .fetch(command.class) { raise UnregisteredHandler.new("Missing handler for #{command.class}")  }
        .(command)
    end

    private
    attr_reader :handlers
  end
end
