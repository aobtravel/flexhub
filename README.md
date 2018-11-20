# Flexhub
Experimental gem which makes it easy to manage data sets like tables.

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

```ruby
Flexhub.setup do |config|
  config.default_table_options = {
    paginate: true,
    paginate_per_page: 25
  }

  # config.filter(:humanize, lambda { |value, argument| value.try(:humanize) })
  config.initialize_default_filters
end
```

## Sample

```ruby
def index
  options = {
    page: params[:page],
    table: {
      paginate: true,
      paginate_per_page: 25
    }
  }

  extractFields = [
    { field: :id, filter: lambda { |item| "##{item}" } }, 
    { field: :login, html: { style: "font-weight: bold;" } }, 
    { field: :name, filter: :humanize }, 
    { field: :mail }
  ]

  dataSet = Flexhub::DataSetActiveRecord.new(User.all)
  table = Flexhub::Table.new(dataSet)
  table.render(extractFields, options: options)
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
