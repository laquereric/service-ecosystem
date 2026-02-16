Rails.application.config.onfido = {
  api_token: ENV["ONFIDO_API_TOKEN"],
  region: ENV.fetch("ONFIDO_REGION", "us").to_sym
}
