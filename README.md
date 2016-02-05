# CommandBus

> Command Pattern - decoupling what is done from who does it.


Usage:

```ruby
require 'command_bus'

command_bus = CommandBus.new
register    = command_bus.method(:register)

{ FooCommand => FooService.new(event_store: event_store).method(:foo),
  BarCommand => BarService.new,
}.map(&:register)


command_bus.(FooCommand.new)

```

Now think how that makes your system simpler and use it or forget and move on.
