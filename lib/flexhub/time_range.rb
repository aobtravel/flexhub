module Flexhub
  class TimeRange
    attr_accessor :start_date, :end_date

    def initialize(start_date, end_date = nil)
      self.start_date = start_date
      self.end_date = end_date
    end

    def start_date_as_i
      return nil if start_date.blank?
      start_date.to_i
    end

    def end_date_as_i
      return nil if end_date.blank?
      end_date.to_i
    end

    class << self
      def from_query(start_date_query, end_date_query = nil)
        TimeRange.new string_to_datetime(start_date_query),
                      string_to_datetime(end_date_query)
      end

      def string_to_datetime(query)
        return nil if query.blank?

        case query
        when "today"      then return Time.now.midnight
        when "yesterday"  then return Time.now.midnight - 1.day
        when "last_hour"  then return 1.hour.ago
        when "this_week"  then return Time.now.beginning_of_week, Time.now.beginning_of_week + 7.days
        when "last_week"  then return Time.now.beginning_of_week - 7.days, Time.now.beginning_of_week
        end

        return interval_string_to_duration(query[5..-1]) if query[0..3] == "last"
        nil
      end

      # Example: 10h => 10.hours.ago
      # Example: 10_hours => 10.hours.ago
      def interval_string_to_duration(query)
        if (query_split = query.split("_")).size >= 2
          num = query_split.first.to_i
          case query_split.last
          when "second", "seconds"  then num.seconds.ago
          when "minute", "minutes"  then num.minutes.ago
          when "hour", "hours"      then num.hours.ago
          when "day", "days"        then num.days.ago
          when "month", "months"    then num.months.ago
          when "year", "years"      then num.years.ago
          else nil
          end
        else
          num = query.to_i
          case query[-1..-1]
          when "s" then num.seconds.ago
          when "m" then num.minutes.ago
          when "h" then num.hours.ago
          when "d" then num.days.ago
          when "M" then num.months.ago
          when "y" then num.years.ago
          else nil
          end
        end
      end

      def time_range_collection
        [
          ["Today", "today"],
          ["Yesterday", "yesterday"],
          ["Last 15 minutes", "last_15m"],
          ["Last 30 minutes", "last_30m"],
          ["Last 1 hour", "last_hour"],
          ["Last 4 hour", "last_4h"],
          ["Last 12 hour", "last_12h"],
          ["Last 24 hours", "last_24h"],
          ["Last 48 hours", "last_48h"],
          ["Last 7 days", "last_week"]
        ]
      end

      def time_range_collection_grouped
        [
          [
            "1",
            [
              ["Today", "today"],
              ["Yesterday", "yesterday"],
              ["This week", "this_week"],
              ["This month", "this_month"],
              ["This year", "this_year"]
            ]
          ],
          [
            "2",
            [
              ["Last 15 minutes", "last_15m"],
              ["Last 30 minutes", "last_30m"],
              ["Last 1 hour", "last_1h"],
              ["Last 4 hour", "last_4h"],
              ["Last 12 hour", "last_12h"],
              ["Last 24 hour", "last_24h"],
              ["Last 7 days", "last_week"]
            ]
          ],
          [
            "3",
            [
              ["Last 30 days", "last_30d"],
              ["Last 60 days", "last_60d"],
              ["Last 90 days", "last_90d"],
              ["Last 6 months", "last_6M"],
              ["Last 1 year", "last_1y"],
              ["Last 2 year", "last_2y"],
              ["Last 5 year", "last_5y"]
            ]
          ],
          [
            "4",
            [
              ["Today so far", "to_date_today"],
              ["Week to date", "to_date_week"],
              ["Month to date", "to_date_month"],
              ["Year to date", "to_date_year"],
            ]
          ]
        ]
      end
    end
  end
end
