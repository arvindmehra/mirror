class CreateSubscriptionswrong < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, index: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :tier
      t.string :receipt_id

      t.timestamps
    end
  end
end