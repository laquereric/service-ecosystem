# Rails application template for engine-github host app
# Usage: rails new rails_app -m template/template.rb

# Add the engine-github engine gem (path relative to generated app)
gem "engine-github", path: "../../engine/engine-github", require: "engine_github"

# Ecosystem library gems (resolve locally when in monorepo)
if Dir.exist?(File.expand_path("../../../library/service-exception", __dir__))
  gem "service-exception", path: "../../../library/service-exception"
end
if Dir.exist?(File.expand_path("../../../library/service-biological-it", __dir__))
  gem "service-biological-it", path: "../../../library/service-biological-it"
end

# libgit2 bindings for Ruby — used for browsing repos in the web UI
gem "rugged"

# LLM engine for Anthropic API access (key injected via docker/.env.secrets)
gem "llm_engine", path: "/workspace/library/llm-engine-gem"
gem "anthropic"

# Copy all files from template/files/ into the generated app
directory File.expand_path("files", __dir__), ".", force: true

# Set up routes
route <<~ROUTES
  # Mount the engine-github engine API
  mount EngineGithub::Engine, at: "/github"

  # LLM health-check endpoint
  mount LlmEngine::Engine, at: "/llm" if defined?(LlmEngine)

  # Repository CRUD
  resources :repositories, only: %i[new create]

  root "repositories#index"

  # Git Smart HTTP protocol endpoints (must match *.git URLs)
  constraints(repo_name: /[a-zA-Z0-9._-]+/) do
    scope "/:repo_name.git" do
      get  "info/refs", to: "git_http#info_refs"
      post "git-upload-pack", to: "git_http#upload_pack"
      post "git-receive-pack", to: "git_http#receive_pack"
    end
  end

  # Web UI for repository browsing
  constraints(repo_name: /[a-zA-Z0-9._-]+/) do
    delete "/:repo_name", to: "repositories#destroy", as: :repository_delete
    get "/:repo_name", to: "repositories#show", as: :repository
    get "/:repo_name/tree/:ref/*path", to: "repositories#tree", as: :repository_tree, format: false
    get "/:repo_name/blob/:ref/*path", to: "repositories#blob", as: :repository_blob, format: false
    get "/:repo_name/commits/:ref", to: "repositories#commits", as: :repository_commits
  end
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
