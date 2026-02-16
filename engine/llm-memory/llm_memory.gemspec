# frozen_string_literal: true

require_relative "lib/llm_memory/version"

Gem::Specification.new do |spec|
  spec.name = "llm-memory"
  spec.version = LlmMemory::VERSION
  spec.authors = ["Eric Laquer"]
  spec.email = ["LaquerEric@gmail.com"]

  spec.summary = "LLM Memory Rails Engine"
  spec.description = "Rails Engine for collecting facts from llm-state, Rails logs, and OpenTelemetry, " \
                     "applying medallion processing (bronze/silver/gold) to produce refined lifecycle inputs."
  spec.homepage = "https://github.com/laquereric/llm-memory"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/laquereric/llm-memory"
  spec.metadata["changelog_uri"] = "https://github.com/laquereric/llm-memory/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "view_component", "~> 3.0"
end
