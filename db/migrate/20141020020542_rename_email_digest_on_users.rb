class RenameEmailDigestOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :email_digest, :encrypted_email
  end
end
