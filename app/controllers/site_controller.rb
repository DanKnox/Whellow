require 'hmac-sha1'
require 'base64'

class SiteController < ApplicationController


  def index
  end

  def posts
    since = (Time.now.to_i - 3600) * 1000
    binding.pry
    posts = fb + twitter
    render json: posts.sort_by{|p|p[:at]}
  end

  def callback
    auth = request.env['omniauth.auth']
    unless user = User.where({:"#{auth.provider}_token" => auth.credentials.token}).first
      user = User.new
      user.name = auth.info.name
      user.save
      auto_login user
    end
    current_user["#{auth.provider}_token"] = auth.credentials.token
    current_user["#{auth.provider}_secret"] = auth.credentials.secret if auth.provider == 'twitter'
    current_user.save
    redirect_to '/'
  end

  def settings
    current_user.update_attributes params[:user]
    redirect_to '/'
  end

  def signup
    user = User.create params[:user]
    auto_login user
    redirect_to '/'
  end

  def signin
    cookies[:access_token] = current_user.token if login( params[:email], params[:password] )
    redirect_to '/'
  end

  def logged_in
    render json: { authed: logged_in?, user: current_user }
  end

  def signout
    logout
    redirect_to '/'
  end

end
