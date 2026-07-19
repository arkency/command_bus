require 'arkency/command_bus/version'
require 'concurrent/map'

module Arkency
  class CommandBus
    UnregisteredHandler = Class.new(StandardError)
    MultipleHandlers    = Class.new(StandardError)

    def initialize(instrumentation = nil)
      @handlers = Concurrent::Map.new
      @instrumentation = instrumentation || NoOpInstrumentation.new
    end

    def register(klass, handler)
      raise MultipleHandlers, "Multiple handlers not allowed for #{klass}" if handlers[klass]

      instrumentation.instrument(
        'register.command_bus',
        handler: handler,
        klass: klass
      ) do
        handlers[klass] = handler
      end
    end

    def call(command)
      handler = handlers.fetch(command.class) do
        raise UnregisteredHandler, "Missing handler for #{command.class}"
      end

      instrumentation.instrument(
        'call.command_bus',
        handler: handler,
        command: command
      ) do
        handler.call(command)
      end
    end

    private

    attr_reader :handlers, :instrumentation

    class NoOpInstrumentation
      def instrument(_name, payload = {})
        yield payload if block_given?
      end
    end
  end
end
