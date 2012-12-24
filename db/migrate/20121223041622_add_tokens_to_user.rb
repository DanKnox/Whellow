class AddTokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :twitter_token, :string
    add_column :users, :linkedin_token, :string
  end
end
