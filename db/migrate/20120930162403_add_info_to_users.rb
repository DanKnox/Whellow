class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :text, :limit => nil
    add_column :users, :uid, :string
    add_column :users, :name, :string
  end
end
