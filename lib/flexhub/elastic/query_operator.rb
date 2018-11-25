module Elastic
  module Operators
    def elastic_filter(parameter, value)
      if value.class == Array
        if value[0].class == String
          case value[0]
          when "=" then elastic_match(parameter, value[1])
          else elastic_range(parameter, value[1], value[0])
          end
        else
          elastic_match_ids(parameter, value)
        end
      else
        elastic_match(parameter, value)
      end
    end

    def elastic_match(parameter, value)
      if value
        result = { match: {} }
        result[:match][parameter] = value
        result
      else
        { exists: { field: parameter } }
      end
    end

    def elastic_match_ids(parameter, values)
      result = { ids: {} }
      result[:ids][:type] = parameter
      result[:ids][:values] = values
      result
    end

    def elastic_range(parameter, value, operator_string = nil, operator: nil)
      if value.class == Array
        operator_string = value.first
        value = value.last
      end

      operator ||= elastic_range_operator(operator_string)

      result = { range: {} }
      result[:range][parameter] = {}
      result[:range][parameter][operator] = value
      result
    end

    def elastic_range_operator(operator_string)
      case operator_string
      when ">=", "=>" then :gte
      when "<=", "=<" then :lte
      when ">" then :gt
      when "<" then :lt
      end
    end
      
    def create_operator(param, value, type, options)
      case type
      when :float, :integer then QueryOperators.elastic_filter(param, value)
      when :string          then QueryOperators.elastic_filter(param, value)
      when :true_class      then bool_operator(param, value, options)
      when :date            then date_operator(param, value, options)
      else                       QueryOperators.elastic_match(param, value)
      end
    end

    def bool_operator(param, value, _options = {})
      if value.class == Array
        QueryOperators.elastic_match(param, value.last.present?)
      else
        QueryOperators.elastic_match(param, value.present?)
      end
    end

    def date_operator(param, value, options = {})
      if options[:operator]
        QueryOperators.elastic_range(param, value, operator: options[:operator])
      else
        if value.class == Array && value.first.class == String
          QueryOperators.elastic_range(param, value)
        else
          QueryOperators.elastic_filter(param, value)
        end
      end
    end

    def to_array(value)
      return value if value.class == Array
      [value]
    end

    extend self
  end
end
