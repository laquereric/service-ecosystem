require "open3"

class GitHttpController < ApplicationController
  skip_forgery_protection

  before_action :find_repository

  # GET /:repo_name.git/info/refs?service=git-upload-pack
  # GET /:repo_name.git/info/refs?service=git-receive-pack
  def info_refs
    service = params[:service]

    unless %w[git-upload-pack git-receive-pack].include?(service)
      head :forbidden
      return
    end

    cmd = [service, "--stateless-rpc", "--advertise-refs", @repository.path]

    refs_output = run_git_command(cmd)

    content_type = "application/x-#{service}-advertisement"

    # Smart HTTP requires a pkt-line header
    pkt = pkt_line("# service=#{service}\n") + pkt_flush
    body = pkt + refs_output

    render body: body, content_type: content_type, status: :ok
  end

  # POST /:repo_name.git/git-upload-pack
  def upload_pack
    run_service("git-upload-pack")
  end

  # POST /:repo_name.git/git-receive-pack
  def receive_pack
    run_service("git-receive-pack")
  end

  private

  def find_repository
    repo_name = params[:repo_name]
    @repository = Repository.find_by!(name: repo_name)
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def run_service(service)
    cmd = [service, "--stateless-rpc", @repository.path]
    input = request.body.read

    output = run_git_command(cmd, stdin_data: input)

    render body: output,
           content_type: "application/x-#{service}-result",
           status: :ok
  end

  def run_git_command(cmd, stdin_data: nil)
    env = { "GIT_PROJECT_ROOT" => ENV.fetch("REPO_STORAGE_PATH", "/data/repositories") }

    stdout, stderr, status = Open3.capture3(env, *cmd, stdin_data: stdin_data || "", binmode: true)

    unless status.success?
      Rails.logger.error("Git command failed: #{cmd.join(' ')}\nstderr: #{stderr}")
      error = RuntimeError.new("Git command failed: #{cmd.first} (exit #{status.exitstatus})")
      ServiceGithub::ExceptionReporter.report(error, metadata: { cmd: cmd.first, stderr: stderr.truncate(500) })
    end

    stdout
  end

  def pkt_line(data)
    len = data.length + 4
    format("%04x", len) + data
  end

  def pkt_flush
    "0000"
  end
end
