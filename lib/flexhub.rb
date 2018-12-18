# frozen_string_literal: true

# TODO: Mime::Type.register "application/xls", :xls

require "flexhub/array_extension"
require "flexhub/filter"
require "flexhub/time_range"

module Flexhub
  autoload :Table,  "flexhub/table"
  autoload :Render, "flexhub/render"
  autoload :TimeRange, "flexhub/time_range"

  # test config
  mattr_accessor :test_config_value
  @@test_config_value = nil

  # Default way to set up Flexhub.
  def self.setup
    yield self
  end
end

require "flexhub/rails"
require "flexhub/railtie" if defined?(Rails::Railtie)
