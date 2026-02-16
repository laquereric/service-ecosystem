# frozen_string_literal: true

# Rails application template for container-switch host app
# Usage: rails new rails_app --api -m template/template.rb

# Add the engine-switch engine gem (path relative to generated app)
gem "engine-switch", path: "../../engine/engine-switch", require: "engine_switch"

# LLM engine for Anthropic API access (key injected via docker/.env.secrets)
gem "llm_engine", path: "/workspace/library/llm-engine-gem"
gem "anthropic"

# Ecosystem library gems (resolve locally when in monorepo, otherwise from gemspec deps)
if Dir.exist?(File.expand_path("../../../library/service-exception", __dir__))
  gem "service-exception", path: "../../../library/service-exception"
end
if Dir.exist?(File.expand_path("../../../library/service-biological-it", __dir__))
  gem "service-biological-it", path: "../../../library/service-biological-it"
end

# Copy all files from template/files/ into the generated app
directory File.expand_path("files", __dir__), ".", force: true

# Set up routes
route <<~ROUTES
  # Mount the engine-switch engine
  mount EngineSwitch::Engine, at: "/protocols"

  # LLM health-check endpoint
  mount LlmEngine::Engine, at: "/llm" if defined?(LlmEngine)

  # Health check
  root to: proc { [200, { "Content-Type" => "application/json" }, ['{"status":"ok"}']] }
ROUTES

# Configure production environment to accept all hosts
environment 'config.hosts.clear', env: "production"

# Make bin scripts executable
after_bundle do
  chmod "bin/setup", 0o755
  chmod "bin/dev", 0o755
  chmod "bin/ci", 0o755
  chmod "bin/jobs", 0o755
end
