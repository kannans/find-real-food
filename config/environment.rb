# Load the rails application
require File.expand_path('../application', __FILE__)
FACEBOOK_CONFIG = YAML.load(File.read("#{Rails.root}/config/facebook.yml"))[Rails.env]
# Initialize the rails application
RealFood::Application.initialize!
