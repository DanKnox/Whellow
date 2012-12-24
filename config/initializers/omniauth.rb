Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], scope: 'read_stream'
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end