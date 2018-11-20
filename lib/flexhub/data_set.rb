module Flexhub
  class DataSet
    def initialize()
      raise NotImplementedError.new("You must implement #{name}.")
    end

    def as_page(offset, limit)
      raise NotImplementedError.new("You must implement #{name}.")
    end

    def in_batches(of: 1000, start: nil)
      raise NotImplementedError.new("You must implement #{name}.")
    end
  end
end
