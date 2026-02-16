class RepositoriesController < ApplicationController
  before_action :find_repository, only: %i[show destroy commits blob tree]

  def index
    @repositories = Repository.order(updated_at: :desc)
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = RepositoryService.create(
      name: params[:repository][:name],
      description: params[:repository][:description]
    )
    redirect_to repository_path(@repository.name), notice: "Repository created."
  rescue => e
    @repository = Repository.new(name: params[:repository][:name], description: params[:repository][:description])
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def show
    if @repository.empty?
      @entries = []
    else
      @ref = params[:ref] || "HEAD"
      tree = @repository.tree_at(@ref)
      @entries = tree_entries(tree)
    end
  end

  def tree
    @ref = params[:ref] || "HEAD"
    @path = params[:path]

    tree = @repository.tree_at(@ref)
    # Walk into the subtree
    @path.split("/").each do |part|
      entry = tree[part]
      if entry && entry[:type] == :tree
        tree = @repository.rugged_repo.lookup(entry[:oid])
      else
        head :not_found
        return
      end
    end

    @entries = tree_entries(tree)
    render :show
  end

  def blob
    @ref = params[:ref] || "HEAD"
    @path = params[:path]

    tree = @repository.tree_at(@ref)
    return head(:not_found) unless tree

    # Walk to the blob
    parts = @path.split("/")
    parts[0..-2].each do |part|
      entry = tree[part]
      if entry && entry[:type] == :tree
        tree = @repository.rugged_repo.lookup(entry[:oid])
      else
        return head(:not_found)
      end
    end

    entry = tree[parts.last]
    return head(:not_found) unless entry && entry[:type] == :blob

    blob = @repository.rugged_repo.lookup(entry[:oid])
    @filename = parts.last
    @content = blob.content.force_encoding("UTF-8")
    @binary = !@content.valid_encoding?
  end

  def commits
    @ref = params[:ref] || "HEAD"
    @commits = []

    unless @repository.empty?
      walker = Rugged::Walker.new(@repository.rugged_repo)
      target = @repository.rugged_repo.rev_parse(@ref)
      target = target.target if target.respond_to?(:target) && !target.is_a?(Rugged::Commit)
      walker.push(target.oid)
      walker.each { |c| @commits << c }
    end
  end

  def destroy
    RepositoryService.delete(@repository)
    redirect_to root_path, notice: "Repository '#{@repository.name}' deleted."
  end

  private

  def find_repository
    @repository = Repository.find_by!(name: params[:repo_name])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Repository not found."
  end

  def tree_entries(tree)
    entries = []
    tree.each do |entry|
      entries << entry
    end
    # Sort: directories first, then files, alphabetically
    entries.sort_by { |e| [e[:type] == :tree ? 0 : 1, e[:name].downcase] }
  end
end
