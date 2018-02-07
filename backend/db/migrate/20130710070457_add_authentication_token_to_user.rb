class AddAuthenticationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_index  :users, :authentication_token, unique: true
    add_column :users, :is_superuser, :boolean, default: false
  end
end