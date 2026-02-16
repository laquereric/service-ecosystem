class Repository < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: true,
                   format: { with: /\A[a-zA-Z0-9._-]+\z/, message: "only allows letters, numbers, dots, hyphens, and underscores" }
  validates :path, presence: true

  before_validation :set_path, on: :create

  def bare_path
    path
  end

  def rugged_repo
    @rugged_repo ||= Rugged::Repository.new(path) if File.directory?(path)
  end

  def empty?
    repo = rugged_repo
    return true unless repo
    repo.empty?
  end

  def head_commit
    return nil if empty?
    rugged_repo.head.target
  end

  def tree_at(ref = "HEAD")
    return nil if empty?
    object = rugged_repo.rev_parse(ref)
    object = object.target if object.is_a?(Rugged::Reference)
    commit = object.is_a?(Rugged::Commit) ? object : rugged_repo.lookup(object.oid)
    commit.tree
  end

  private

  def set_path
    return if name.blank?
    storage = ENV.fetch("REPO_STORAGE_PATH", "/data/repositories")
    self.path = File.join(storage, "#{name}.git")
  end
end
