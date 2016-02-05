require 'command_bus/version'
require 'thread_safe/cache'

class CommandBus
  def initialize
    @handlers =
      ThreadSafe::Cache.new
  end

  def register(klass, handler)
    handlers[klass] = handler
  end

  def call(command)
    handlers[command.class].(command)
  end

  private
  attr_reader :handlers
end
