class Product < ActiveRecord::Base

  validates_presence_of :duration_in_months, :on_sale

  def ios_transactions
    Transaction.where(platform: "ios", bundle_name: bundle_name_ios)
  end

  def android_transactions
    Transaction.where(platform: "android", bundle_name: bundle_name_android)
  end

  def transactions
    Transaction.where('(platform = ? AND bundle_name = ?) OR (platform = ? AND bundle_name = ?)', "ios", bundle_name_ios, "android", bundle_name_android)
  end

end
