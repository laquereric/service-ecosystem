# Rails application template for engine-id host app
# Usage: rails new rails_app -m template/template.rb

# Add the engine-id engine gem (path relative to generated app)
gem "engine-id", path: "../../engine/engine-id", require: "engine_id"

# LLM engine for Anthropic API access (key injected via docker/.env.secrets)
gem "llm_engine", path: "/workspace/library/llm-engine-gem"
gem "anthropic"

# Copy all files from template/files/ into the generated app
directory File.expand_path("files", __dir__), ".", force: true

# Set up routes
route <<~ROUTES
  # Mount the engine-id engine API
  mount EngineId::Engine, at: "/id"

  # LLM health-check endpoint
  mount LlmEngine::Engine, at: "/llm" if defined?(LlmEngine)

  # Web UI for identity browsing
  resources :identities, only: %i[index show new create edit update]

  root "identities#index"
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
