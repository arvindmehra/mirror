class RenameUserFields < ActiveRecord::Migration
  def change
    rename_column :users, :reset_password_token, :password_reset_token
    rename_column :users, :reset_password_token_sent_at, :password_reset_token_sent_at
  end
end
