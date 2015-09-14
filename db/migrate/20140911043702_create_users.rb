class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_hash
      t.string :password_hash
      t.string :auth_token
      t.string :reset_password_token
      t.datetime :reset_password_token_sent_at

      t.timestamps
    end
  end
end
