# Command Bus

> Command Pattern - decoupling what is done from who does it.

## Installation

Notice this gem is namespaced.

    gem install arkency-command_bus

## Usage

```ruby
require 'arkency/command_bus'

command_bus = Arkency::CommandBus.new
register    = command_bus.method(:register)

{ FooCommand => FooService.new(event_store: event_store).method(:foo),
  BarCommand => BarService.new,
}.map(&register)


command_bus.(FooCommand.new)

```

### New instance of a service for every command

If need a new instance of a service every time it is called with a command or you want to lazily load the responsible services, you can just use `Proc` during registration.

```ruby
command_bus = Arkency::CommandBus.new
command_bus.register(FooCommand, -> (foo_cmd) { FooService.new(event_store: event_store).foo(foo_cmd) })
command_bus.register(BarCommand, -> (bar_cmd) { BarService.new.call(bar_cmd) })
```

Alternatively, you can register a Class and it will be instantiated per call.

```ruby
command_bus = Arkency::CommandBus.new
command_bus.register(FooCommand, FooService)
```

If the Class, itself, defines `call`, the Class will continue to be used instead of instantiated.

### Working with Rails development mode

In Rails `development` mode when you change a registered class, it is reloaded, and a new class with same name is constructed.

```ruby
a = User
a.object_id
# => 40737760

reload!
# Reloading...

b = User
b.object_id
# => 48425300

h = {a => 1, b => 2}
h[User]
# => 2

a == b
# => false
```

so your `Hash` with mapping from command class to service may not find the new version of reloaded class.

To workaround this problem you can use [`to_prepare`](http://api.rubyonrails.org/classes/Rails/Railtie/Configuration.html#method-i-to_prepare) callback which is executed before every code reload in development, and once in production.

```ruby
config.to_prepare do
  config.command_bus = Arkency::CommandBus.new
  register = command_bus.method(:register)

  { FooCommand => FooService.new(event_store: event_store).method(:foo),
    BarCommand => BarService.new,
  }.map(&register)
end
```

and call it with

```ruby
Rails.configuration.command_bus.call(FooCommand.new)
```

## Convenience alias

```ruby
require 'arkency/command_bus/alias'
```

From now on you can use top-level `CommandBus` instead of `Arkency::CommandBus`.

## About

<img src="http://arkency.com/images/arkency.png" alt="Arkency" width="20%" align="left" />

Command Bus is funded and maintained by Arkency. Check out our other [open-source projects](https://github.com/arkency).

You can also [hire us](http://arkency.com) or [read our blog](http://blog.arkency.com).

## Learn more about DDD & Event Sourcing

Check our **Rails + Domain Driven Design Workshop** [more details](http://blog.arkency.com/ddd-training/).

Why You should attend? Robert has explained this in [this blogpost](http://blog.arkency.com/2016/12/why-would-you-even-want-to-listen-about-ddd/).

Next edition will be held in **September 2017** (Thursday & Friday) in Berlin, Germany.
Workshop will be held in English.
