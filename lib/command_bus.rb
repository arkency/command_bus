require 'command_bus/version'
require 'thread_safe'

class CommandBus
  UnregisteredHandler = Class.new(StandardError)

  def initialize
    @handlers =
      ThreadSafe::Cache.new
  end

  def register(klass, handler)
    handlers[klass] = handler
  end

  def call(command)
    handlers
      .fetch(command.class) { raise UnregisteredHandler.new(message(command))  }
      .(command)
  end

  private
  attr_reader :handlers

  def message(command)
    "Missing handler for #{command.class}"
  end
end
