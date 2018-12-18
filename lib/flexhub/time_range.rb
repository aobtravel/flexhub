module Flexhub
  class TimeRange
    def start_date
      @start_date
    end

    def end_date
      @end_date
    end

    def initialize(start_date, end_date = nil)
      @start_date = start_date
      @end_date = end_date
    end

    def self.from_query(query)
      case query
      when "today"      then return TimeRange.new(Time.now.midnight)
      when "yesterday"  then return TimeRange.new(Time.now.midnight - 1.day)
      when "last_hour"  then return TimeRange.new(1.hour.ago)
      when "this_week"  then return TimeRange.new(Time.now.beginning_of_week, Time.now.beginning_of_week + 7.days)
      when "last_week"  then return TimeRange.new(Time.now.beginning_of_week - 7.days, Time.now.beginning_of_week)
      end

      return query_to_date(query[5..-1]) if query[0..3] == "last"

      nil
    end

    # Example: 10h => 10.hours.ago
    def self.query_to_date(query)
      num = query.to_i
      case query[-1..-1]
      when "s" then TimeRange.new(num.seconds.ago)
      when "m" then TimeRange.new(num.minutes.ago)
      when "h" then TimeRange.new(num.hours.ago)
      when "d" then TimeRange.new(num.days.ago)
      when "M" then TimeRange.new(num.months.ago)
      when "y" then TimeRange.new(num.years.ago)
      end
    end
  end
end
