class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :product
  belongs_to :receipt
  belongs_to :subscription

  validates_presence_of :bundle_name, :transaction_number, :orig_purchase_time, :receipt, :product, :user, :subscription
end
