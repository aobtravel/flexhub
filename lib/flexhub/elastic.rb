require "elasticsearch"

module Elastic
  def self.connection
    @conn ||= ConnectionPool.new(size: 5, timeout: 5) {
      Elasticsearch::Client.new host: ENV["ELASTICSEARCH_ADDRESS"],
                                request_timeout: 60
    }
  end

  def is_online?
    @is_online ||= Elastic::Api::ElasticModule.connection.with { |conn| conn.ping }
  rescue
    false
  end
end

Elastic.connection
