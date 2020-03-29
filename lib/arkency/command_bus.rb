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
      handlers[klass] = handler
    end

    def call(command)
      handler = handlers.fetch(command.class) { raise UnregisteredHandler, "Missing handler for #{command.class}" }
      handler = handler.new if Class === handler
      handler.call(command)
    end

    private
    attr_reader :handlers
  end
end
