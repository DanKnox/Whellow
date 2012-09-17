class SiteController < ApplicationController


  def index
  end

  def posts
  	since = (Time.now.to_i - 43200) * 1000
  	fb = HTTParty.get('https://api.singly.com/v0/services/facebook/home', { query: { limit: 50, since: since, access_token: cookies[:access_token] } }).parsed_response
  	twitter = HTTParty.get('https://api.singly.com/v0/services/twitter/timeline', { query: { limit: 50, since: since, access_token: cookies[:access_token] } }).parsed_response
    posts = fb + twitter
    render json: posts.sort_by{|p|p[:at]}
  end

  def callback
  	auth = request.env['omniauth.auth']
  	cookies[:access_token] = auth.credentials.token
  	redirect_to '/'
  end

end