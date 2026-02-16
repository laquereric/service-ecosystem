# Rails application template for engine-3d host app
# Usage: rails new rails_app -m template/template.rb

# Add the engine-3d engine gem (path relative to generated app)
gem "engine-3d", path: "../../engine/engine-3d", require: "engine_3d"

# Engine dependencies the host app needs
gem "view_component"

# LLM engine for Anthropic API access (key injected via docker/.env.secrets)
gem "llm_engine", path: "/workspace/library/llm-engine-gem"
gem "anthropic"

# Ecosystem library gems (resolve locally when in monorepo)
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
  # Mount the engine-3d engine (standalone Inertia scenes)
  mount Engine3d::Engine, at: "/3d"

  # LLM health-check endpoint
  mount LlmEngine::Engine, at: "/llm" if defined?(LlmEngine)

  root "dashboards#index"
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
