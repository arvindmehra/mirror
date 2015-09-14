class RenameEmailOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :email_hash, :email_digest
    rename_column :users, :password_hash, :password_digest
  end
end
