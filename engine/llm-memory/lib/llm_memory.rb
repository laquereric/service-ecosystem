# frozen_string_literal: true

require_relative "llm_memory/version"
require_relative "llm_memory/configuration"
require_relative "llm_memory/engine" if defined?(Rails)

module LlmMemory
  class Error < StandardError; end

  TIERS = %w[bronze silver gold].freeze
  SOURCE_TYPES = %w[llm_state rails_log open_telemetry].freeze

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
