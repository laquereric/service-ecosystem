# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# MCP: Sample tool
ServiceSwitch::McpTool.find_or_create_by!(name: "echo") do |tool|
  tool.description = "Echoes the input back to the caller"
  tool.input_schema = {
    type: "object",
    properties: {
      message: { type: "string", description: "The message to echo" }
    },
    required: ["message"]
  }
end

# MCP: Sample resource
ServiceSwitch::McpResource.find_or_create_by!(uri: "resource://service-switch/status") do |resource|
  resource.name = "Service Status"
  resource.description = "Current status of the service-switch engine"
  resource.mime_type = "application/json"
end

# MCP: Sample prompt
ServiceSwitch::McpPrompt.find_or_create_by!(name: "greeting") do |prompt|
  prompt.description = "A simple greeting prompt template"
  prompt.arguments = [
    { name: "name", description: "Name of the person to greet", required: true }
  ]
end

# ACP: Sample agent
ServiceSwitch::AcpAgent.find_or_create_by!(name: "echo-agent") do |agent|
  agent.description = "A sample agent that echoes messages back"
  agent.manifest = {
    capabilities: ["echo", "ping"],
    version: "1.0.0"
  }
  agent.active = true
end

# A2A: Sample agent card
ServiceSwitch::A2aAgentCard.find_or_create_by!(agent_id: "service-switch-agent") do |card|
  card.name = "Service Switch Agent"
  card.description = "Multi-protocol agent communication service"
  card.endpoint = "/protocols/a2a/messages"
  card.capabilities = {
    streaming: true,
    pushNotifications: true
  }
  card.skills = [
    { id: "echo", name: "Echo", description: "Echoes messages back to the sender" }
  ]
end
