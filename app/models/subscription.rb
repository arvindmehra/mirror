class Subscription < ActiveRecord::Base

  belongs_to :user
  has_many :transactions
  validates_presence_of :user, :start_date, :end_date

  def is_active?
    start_date <= Time.now && Time.now < end_date
  end

  def generate_start_and_end_date()
    self.start_date = calculate_start_date_of_subscription()
    duration_of_subscription_months = 0

    self.transactions.each do |transaction|
      duration_of_subscription_months += transaction.product.duration_in_months
    end

    self.end_date = start_date + duration_of_subscription_months.months
  end

  def generate_transactions(receipt_as_json, receipt)
    if receipt.platform.to_s == :ios.to_s
      build_apple_transactions(receipt_as_json, receipt)
    end
  end

  def build_apple_transactions(receipt_as_json, receipt)
    bundle_name = receipt_as_json[:receipt.to_s][:bundle_id.to_s]

    receipt_as_json[:receipt.to_s][:in_app.to_s].each do |transaction|
      transaction_number = transaction[:transaction_id.to_s]
      trans_product_name = transaction[:product_id.to_s]

      unless Transaction.where(transaction_number: transaction_number, product: Product.where(name: trans_product_name)).exists?
        
        trans_orig_purchase_date_millis = transaction[:original_purchase_date_ms.to_s]
        trans_orig_purchase_date_utc = Time.at(trans_orig_purchase_date_millis.to_i / 1000).utc
        
        self.transactions.build(receipt: receipt, user: self.user, orig_purchase_time: trans_orig_purchase_date_utc, bundle_name: bundle_name, product: Product.where(name: trans_product_name).first, transaction_number: transaction_number)
      end
    end
  end

  private
    def calculate_start_date_of_subscription
      if latest_subscription = self.user.subscriptions.order("end_date DESC").first
        # if last subscription expired before renewel
        if latest_subscription.end_date > Time.now
          return latest_subscription.end_date
        end
      else
        return calculate_earliest_new_transaction_purchase_time()
      end
      #there is a subscription but it has since expired
      return calculate_earliest_new_transaction_purchase_time()
    end

    def calculate_earliest_new_transaction_purchase_time()
      earliest_transaction_purchase_time = nil

      self.transactions.each do |transaction|
        if earliest_transaction_purchase_time
          if transaction.orig_purchase_time < earliest_transaction_purchase_time
            earliest_transaction_purchase_time = transaction.orig_purchase_time
          end
        else
          earliest_transaction_purchase_time = transaction.orig_purchase_time
        end
      end

      return earliest_transaction_purchase_time
    end
  
end
