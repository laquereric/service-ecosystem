# frozen_string_literal: true

module LlmMemory
  class Configuration
    attr_accessor :rails_log_path, :otel_endpoint, :collection_interval, :enable_service_node

    def initialize
      @rails_log_path = nil
      @otel_endpoint = nil
      @collection_interval = 60
      @enable_service_node = false
    end
  end
end
