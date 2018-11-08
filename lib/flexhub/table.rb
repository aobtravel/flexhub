module Flexhub
  class Table
    attr_reader :title, :actions, :headers, :content,
                :show_status, :max_columns,
                :records_per_page

    def initialize(opts = {})
      @title = opts[:title]
      @actions = opts[:actions]
      @headers = opts[:headers]
      @max_columns = @headers.try(&:size)
      @records_per_page = opts[:records_per_page]
      @show_status = opts[:show_status] || false
      @content = []
    end

    def push(item, opts = {})
      @content << {
        status: opts[:status] || :success,
        link: opts[:link],
        item: item
      }
      @max_columns = item.size if @max_columns < item.size
    end

    def add_action(item)
      @actions ||= []
      @actions << item
    end

    def to_json(args = {})
      to_hash(args).to_json
    end

    def to_hash(args = {})
      {
        title: @title,
        actions: @actions,
        headers: @headers,
        items: @content
      }
    end

    def to_csv(args = {})
      Exporter.to_csv self
    end

    module Exporter
      def self.to_csv(item)
        csv = "#{item.title};\r\n\r\n"

        item.headers.each do |header|
          csv += "#{header};"
        end
        csv += "\r\n"

        item.content.each do |chunk|
          chunk[:item].each do |item|
            csv += "#{item};"
          end
          csv += "\r\n"
        end
        csv += "\r\n"
      end
    end
  end
end
