OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '738086279561041', '87fa81ac953200323e87b7c22e0bcbb1', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end