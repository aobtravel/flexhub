# frozen_string_literal: true

module Elastic
  class Query
    RESERVED_AGGS = [:aggs_result]

    def initialize(options = {})
      if options[:raw_query]
        @query = options[:raw_query]
      else
        @query = { query: { bool: {} }}
        @query[:size] = options[:size].to_i if options[:size]
      end
      @logger = options[:logger]
      @logger ||= Rails.logger if Rails.env.development?
      self
    end

    def set_page(offset, size)
      @query[:from] = offset
      @query[:size] = size
    end

    def current_query
      @query
    end

    # def run(index)
    #   QueryResult.new QueryResultParser.new(@query).parse(run_raw(index))
    # end

    def run_raw(index)
      result = connection.with { |conn| conn.search(index: index, body: @query) }
    rescue Faraday::ConnectionFailed,
           Elasticsearch::Transport::Transport::Errors::BadRequest => e
      log_run_error(index, e)
      nil
    ensure
      log_run(index, result)
      result
    end

    def profile(index)
      profile_q = @query
      profile_q[:profile] = true
      result = connection.with { |conn| conn.search(index: index, body: profile_q, human: true) }
    rescue Faraday::ConnectionFailed,
           Elasticsearch::Transport::Transport::Errors::BadRequest => e
      log_run_error(index, e)
      nil
    ensure
      log_run(index, result)
      result
    end

    [:must, :must_not, :should, :filter].each do |method_type|
      define_method method_type do |param, value, type = nil, options = {}|
        add_bool_operator method_type, create_operator(param, value, type, options)
        self
      end

      define_method "#{define_method}_exist" do |param|
        add_bool_operator method_type, { exists: { field: param } }
        self
      end

      define_method "#{define_method}_range_number" do |param, min, max|
        range_query = { range: { } }
        range_query[:range][param] = {}
        range_query[:range][param][:gte] = min.to_i if min
        range_query[:range][param][:lt] = max.to_i if max
        add_bool_operator method_type, range_query
        self
      end

      define_method "#{define_method}_range_date" do |param, min, max|
        range_query = { range: { } }
        range_query[:range][param] = {}
        range_query[:range][param][:gte] = min.to_s(:iso8601) if min
        range_query[:range][param][:lt] = max.to_s(:iso8601) if max
        add_bool_operator method_type, range_query
        self
      end

      define_method "#{define_method}_regex" do |param, value|
        q = {}
        q[param] = value
        add_bool_operator method_type, { regexp: q }
        self
      end
    end

    private

    def log_run(index, result)
      return unless @logger
      msg  = "  ES #{index.to_s.humanize} Load "
      msg += "(#{result.dig("took")}ms, #{result.dig("hits", "total")} results)" if result
      msg = msg.cyan if result
      msg = msg.red unless result
      msg += "  #{@query.to_json}".blue
      @logger.try(:info, msg)
    end

    def log_run_error(index, exception)
      return unless @logger
      msg  = "  ES #{index.to_s.humanize} Load (#{exception.message()})".red
      @logger.try(:info, msg)
      ExceptionHandler.capture_exception(exception, extra: { index: index, query: @query })
    end

    def add_bool_operator(type, value)
      if @query.dig(:query, :bool, type).nil?
        @query[:query] ||= {}
        @query[:query][:bool] ||= {}
        @query[:query][:bool][type] ||= []
      end
      @query[:query][:bool][type] << value
    end

    def validate_aggs_name(name)
      raise "Reserved keyword" if RESERVED_AGGS.include?(name.to_sym)
    end
  end
end
