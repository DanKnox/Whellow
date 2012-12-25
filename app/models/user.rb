class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :token, :uid, :password

  def facebook
    Koala::Facebook::API.new(self.facebook_token).get_connections('me', 'feed')
  end

  def twitter
    t_url = 'https://api.twitter.com/1/statuses/home_timeline.json'
    param_string = "oauth_consumer_key=#{ ENV['TWITTER_KEY'] }&oauth_nonce=#{ rand(36**40).to_s(36) }&oauth_signature_method=HMAC-SHA1&oauth_timestamp=#{ Time.now.to_i }&oauth_token=#{ CGI.escape self.twitter_token }&oauth_version=1.0"
    sig_string = "GET&#{ CGI.escape t_url }&#{ CGI.escape param_string }"
    sig_key = ENV['TWITTER_SECRET'] + '&' + self.twitter_secret
    hmac = HMAC::SHA1.new sig_key
    hmac.update sig_string
    HTTParty.get('https://api.twitter.com/1/statuses/home_timeline.json', headers: { 'Authorization' => "OAuth #{ param_string.split('&').join(', ') }, oauth_signature=#{ CGI.escape( Base64.encode64(hmac.digest)[0..-2] )}" })
  end
end
