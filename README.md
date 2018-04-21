# Flexhub
Experimental gem which makes it easy to manage datasets like tables.

This is designed to be used with [Tabler](https://tabler.github.io/).

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'flexhub'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install flexhub
```

## Sample

```ruby
include Flexhub::Render

...

def index
  table = Flexhub::Table.new title: "Manage users",
                             actions: [{ text: "New", action: "new" }],
                             headers: [ "Login", "Name", "Mail" ]

  Users.order('name').each do |user|
    table.push [ user.login, user.name, user.mail ]
  end

  flexhub_render_view table
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
