raise StandardError.new('CommandBus has been already defined, giving up.') if defined?(::CommandBus)
::CommandBus = Arkency::CommandBus
