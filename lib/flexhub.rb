# frozen_string_literal: true

# TODO: Mime::Type.register "application/xls", :xls

module Flexhub
  autoload :Table,  'flexhub/table'  
  
  autoload :Render, 'flexhub/render' 
  
  # test config
  mattr_accessor :test_config_value
  @@test_config_value = nil

  # Default way to set up Flexhub.
  def self.setup
    yield self
  end
end

require 'flexhub/rails'
