# Rails application template for engine-puml host app
# Usage: rails new rails_app -m template/template.rb

# Add the engine-puml engine gem (path relative to generated app)
gem "engine-puml", path: "../../engine/engine-puml", require: "engine_puml"

# Ecosystem library gems (resolve locally when in monorepo)
if Dir.exist?(File.expand_path("../../../library/service-exception", __dir__))
  gem "service-exception", path: "../../../library/service-exception"
end
if Dir.exist?(File.expand_path("../../../library/service-biological-it", __dir__))
  gem "service-biological-it", path: "../../../library/service-biological-it"
end

# Engine dependencies that need Bundler auto-require in the host app
gem "view_component"
gem "dry-monads"

# LLM engine for Anthropic API access (key injected via docker/.env.secrets)
gem "llm_engine", path: "/workspace/library/llm-engine-gem"
gem "anthropic"

# Copy all files from template/files/ into the generated app
directory File.expand_path("files", __dir__), ".", force: true

# Set up routes
route <<~ROUTES
  # Mount the engine-puml engine
  mount EnginePuml::Engine, at: "/puml"

  # LLM health-check endpoint
  mount LlmEngine::Engine, at: "/llm" if defined?(LlmEngine)

  root "diagrams#index"
ROUTES

# Configure production environment to accept all hosts
environment 'config.hosts.clear', env: "production"

# Make bin scripts executable
after_bundle do
  chmod "bin/setup", 0o755
  chmod "bin/dev", 0o755
end
