module Flexhub
  class DataSetActiveRecord < DataSet
    def initialize(record)
      @record = record
    end

    def as_page(offset, limit)
      record.offset(offset).limit(limit).to_a
    end

    def in_batches(of: 1000, start: nil)
      record.in_batches(of, start) do |item|
        yield(item)
      end
    end
  end
end
