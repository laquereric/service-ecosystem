ServiceGithub.configure do |config|
  config.exception_report_url = ENV["EXCEPTION_REPORT_URL"]
  config.enable_service_node = ENV["ENABLE_SERVICE_NODE"] == "true"
end
