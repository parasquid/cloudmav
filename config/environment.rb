# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Codemav::Application.initialize!

SlideShare.API_KEY = ""
SlideShare.SECRET = ""
API::StackOverflow.API_KEY = ""

LINKEDIN_API_KEY = ""
LINKEDIN_SECRET_KEY = ""

# Twitter.configure do |config|
#  config.consumer_key = ""
#  config.consumer_secret = ""
#  config.oauth_token = ""
#  config.oauth_token_secret = ""
# end