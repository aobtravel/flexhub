class Array
  def to_table(arguments)
    Flexhub.to_table_validate(self, arguments)

    table = ::Flexhub::Table.new headers: Flexhub.to_table_headers(arguments)

    self.map do |item|
      table.push Flexhub.to_table_argument(item, arguments)
    end

    table
  end

  def to_table_array(arguments)
    Flexhub.to_table_validate(self, arguments)
    self.map { |item| Flexhub.to_table_argument(item, arguments) }
  end

  module Flexhub
    def self.to_table_validate(array, arguments)
      # raise "Array content is not a Hash or Object" if array.first.class != Hash ||
      #                                                  array.first.class != Object
    end

    def self.to_table_headers(arguments)
      arguments.map do |item|
        value = item.to_s
        value = (item[:header] || item[:key]).to_s if item.class == Hash
        value.to_s.humanize
      end
    end

    def self.to_table_argument(item, arguments)
      arguments.map do |argument|
        if argument.class == Hash then Array::Flexhub.to_table_hash(item, argument)
        else item[argument].to_s
        end
      end
    end

    def self.to_table_hash(item, argument)
      if argument[:format]
        ::Flexhub.filter_call(argument[:format], item[argument[:key]], argument)
      else
        item[argument[:key]].to_s
      end
    end
  end
end
