module Flexhub
  @filters = {}

  def filter(name, func)
    @filters[name] = func
    nil
  end

  def filter_call(name, value, argument)
    if @filters[name]
      @filters[name].call(value, argument)
    else
      # TODO: Warning
      value.to_s
    end
  end

  def setup_filter
    Flexhub.filter(:humanize, lambda { |value, argument| value.try(:humanize) })
    Flexhub.filter(:upcase,   lambda { |value, argument| value.try(:upcase) })
    Flexhub.filter(:downcase, lambda { |value, argument| value.try(:downcase) })
    Flexhub.filter(:capitalize, lambda { |value, argument| value.try(:capitalize) })
  end

  extend self
end

# [{id: 123, v: "hello"}, {id: 1, v: "hi"}].to_table [:id, {key: :v, format: :humanize}]
