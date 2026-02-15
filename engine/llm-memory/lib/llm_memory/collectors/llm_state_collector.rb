# frozen_string_literal: true

module LlmMemory
  module Collectors
    class LlmStateCollector < BaseCollector
      SOURCE_TYPE = "llm_state"

      def collect
        # Stubbed: will read from llm-state engine via biological-IT
        # Returns array of raw entries for bronze processing
        []
      end
    end
  end
end
