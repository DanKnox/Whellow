require 'hmac-sha1'
require 'base64'

class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :token, :uid, :password

  def facebook
    posts = Koala::Facebook::API.new(self.facebook_token).get_connections('me', 'home')
    
    posts.map! do |post|
      {
        username: post['from']['name'],
        picture: "http://graph.facebook.com/#{ post['from']['id'] }/picture?type=square",
        message: post['message'],
        type: post['status_type'],
        service: 'facebook',
        at: Time.parse(post['created_time']).to_i
      }
    end
    posts.select { |post| post[:message] }
  end

  def twitter
    t_url = 'https://api.twitter.com/1/statuses/home_timeline.json'
    param_string = "oauth_consumer_key=#{ ENV['TWITTER_KEY'] }&oauth_nonce=#{ rand(36**40).to_s(36) }&oauth_signature_method=HMAC-SHA1&oauth_timestamp=#{ Time.now.to_i }&oauth_token=#{ CGI.escape self.twitter_token }&oauth_version=1.0"
    sig_string = "GET&#{ CGI.escape t_url }&#{ CGI.escape param_string }"
    sig_key = ENV['TWITTER_SECRET'] + '&' + self.twitter_secret
    hmac = HMAC::SHA1.new sig_key
    hmac.update sig_string
    posts = HTTParty.get('https://api.twitter.com/1/statuses/home_timeline.json', headers: { 'Authorization' => "OAuth #{ param_string.split('&').join(', ') }, oauth_signature=#{ CGI.escape( Base64.encode64(hmac.digest)[0..-2] )}" })
    
    posts.map! do |post|
      {
        username: post['user']['name'],
        picture: post['user']['profile_image_url'],
        message: post['text'],
        service: 'twitter',
        at: Time.parse(post['created_at']).to_i
      }
    end
    posts.select { |post| post[:message] }
  end
end
