class RepositoryService
  def self.create(name:, description: nil)
    repo = Repository.new(name: name, description: description)

    Repository.transaction do
      repo.save!
      init_bare_repo(repo.path)
    end

    repo
  rescue => e
    # Clean up the bare repo if DB save succeeded but something else failed
    FileUtils.rm_rf(repo.path) if repo.path && File.directory?(repo.path)
    ServiceGithub::ExceptionReporter.report(e, metadata: { operation: "create", name: name })
    raise e
  end

  def self.delete(repo)
    path = repo.path
    Repository.transaction do
      repo.destroy!
      FileUtils.rm_rf(path) if File.directory?(path)
    end
  rescue => e
    ServiceGithub::ExceptionReporter.report(e, metadata: { operation: "delete", name: repo.name })
    raise e
  end

  def self.init_bare_repo(path)
    FileUtils.mkdir_p(File.dirname(path))
    repo = Rugged::Repository.init_at(path, :bare)
    repo.head = "refs/heads/main"
  rescue Rugged::ReferenceError
    # HEAD target doesn't exist yet (empty repo), write it manually
    File.write(File.join(path, "HEAD"), "ref: refs/heads/main\n")
  end
end
