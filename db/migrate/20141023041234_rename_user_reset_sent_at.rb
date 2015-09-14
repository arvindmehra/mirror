class RenameUserResetSentAt < ActiveRecord::Migration
  def change
    rename_column :users, :password_reset_token_sent_at, :password_reset_sent_at
  end
end
