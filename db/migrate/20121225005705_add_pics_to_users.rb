class AddPicsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_avatar, :string
    add_column :users, :twitter_avatar, :string
  end
end
