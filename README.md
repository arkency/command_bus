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
}.map(&:register)


command_bus.(FooCommand.new)

```

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

To workaround this problem you can use [`to_prepare`](http://api.rubyonrails.org/classes/Rails/Railtie/Configuration.html#method-i-to_prepare)

```ruby
config.to_prepare do
  config.command_bus = Arkency::CommandBus.new
  register = command_bus.method(:register)

  { FooCommand => FooService.new(event_store: event_store).method(:foo),
    BarCommand => BarService.new,
  }.map(&:register)
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

From now on you can use top-level `::CommandBus`.

## About

<img src="http://arkency.com/images/arkency.png" alt="Arkency" width="20%" align="left" />

Command Bus is funded and maintained by Arkency. Check out our other [open-source projects](https://github.com/arkency).

You can also [hire us](http://arkency.com) or [read our blog](http://blog.arkency.com).
