# frozen_string_literal: true

module LlmMemory
  class Node < ServiceBiologicalIt::ServiceNode
    def initialize(name: "llm-memory", authenticator: nil, authorizer: nil)
      super(name: name, authenticator: authenticator, authorizer: authorizer)
    end

    def register_bindables
      register(Bindables::LlmMemoryBindable.new)
    end
  end
end
