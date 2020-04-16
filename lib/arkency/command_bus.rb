require 'arkency/command_bus/version'
require 'thread_safe'

module Arkency
  class CommandBus
    UnregisteredHandler = Class.new(StandardError)
    MultipleHandlers    = Class.new(StandardError)

    def initialize
      @handlers =
        ThreadSafe::Cache.new
    end

    def register(klass, handler)
      raise MultipleHandlers.new("Multiple handlers not allowed for #{klass}") if handlers[klass]

      if handler.respond_to?(:call)
        handlers[klass] = handler
      else
        handlers[klass] = -> (command) { handler.new.call(command) }
      end
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
