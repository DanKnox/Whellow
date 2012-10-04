class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :token, :uid, :password, :password_confirmation
end
