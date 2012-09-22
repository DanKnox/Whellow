class SiteController < ApplicationController


  def index
  end

  def posts
  	since = (Time.now.to_i - 43200) * 1000
  	fb = HTTParty.get('https://api.singly.com/v0/services/facebook/home', { query: { limit: 50, since: since, access_token: cookies[:access_token] } }).parsed_response
  	linkedin = HTTParty.get('https://api.singly.com/v0/services/linkedin/network', { query: { limit: 50, since: since, access_token: cookies[:access_token] } }).parsed_response
    posts = fb + linkedin
    render json: posts.sort_by{|p|p[:at]}
  end

  def callback
  	auth = request.env['omniauth.auth']
  	cookies[:access_token] = auth.credentials.token
    current_user.token = auth.credentials.token
    current_user.save
    binding.pry
  	redirect_to '/'
  end

  def signup
    user = User.create params[:user]
    auto_login user
    redirect_to '/'
  end

  def signin
    login( params[:email], params[:password] )
    cookies[:access_token] = current_user.token
    redirect_to '/'
  end

  def logged_in
    render json: { authed: logged_in? }
  end

  def signout
    logout
    redirect_to '/'
  end

end