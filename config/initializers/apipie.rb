Apipie.configure do |config|
  config.app_name                = "RealFood"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/*.rb"
  config.validate = false
  config.validate_value = false
  config.validate_presence = false
  config.app_info = "API documentation for Real Foods"
end
