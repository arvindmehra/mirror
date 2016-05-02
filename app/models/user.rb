class User < ActiveRecord::Base
  include UserReminder
  include UserAuthentication

  has_many :devices
  has_many :notes
  has_many :tags, through: :notes
  has_many :subscriptions
  has_many :transactions
  has_many :receipts
  has_many :user_activities
  has_many :user_notifications

  after_create :create_trial_subscription

  def create_trial_subscription
    self.subscriptions.create(start_date: Time.now, end_date: 10.days.from_now)
  end

  def has_active_subscription?
    active_subscriptions = subscriptions.collect {|subscription| subscription.is_active? }
    return active_subscriptions.any?
  end

  def active_subscription
    subscriptions.where("start_date <= ? AND end_date > ?", Time.now, Time.now).first
  end

  def trial_is_active?
    return self.active_subscription.end_date - self.active_subscription.start_date <= 10.days
  end

  def subscription_not_purchased?
    return self.transactions.empty?
  end

  def subscription_info
    subscription_info = SubscriptionInfo.new
    if self.has_active_subscription?
      subscription_info.has_active_subscription = true
      subscription_info.expires = Time.at(self.subscriptions.order(end_date: :desc).first.end_date).to_formatted_s(:db) + " UTC"
      subscription_info.trial_is_active_and_no_subscription_purchased = trial_is_active? && subscription_not_purchased?
    else
      subscription_info.has_active_subscription = false
      subscription_info.expires = nil
      subscription_info.trial_is_active_and_no_subscription_purchased = nil
    end

    return subscription_info
  end

  def lifetime_acitivity_time
    user_activities.pluck(:time_spent).sum
  end

  def first_activity_date
    user_activities.present? ? user_activities.first.activity_date.to_date : nil
  end

  def activity_goal_time
    activity_goal.present? ? activity_goal : 3   #send 3 minutes if goal is not set
  end


  def suggestion_notifications
    user_notifications.for_suggestion_screen.non_deleted
  end

  def unread_suggestion_notifications
    user_notifications.for_suggestion_screen.non_deleted.unread
  end

  def option_notifications
    user_notifications.for_option_screen.non_deleted
  end

  def unread_option_notifications
    user_notifications.for_option_screen.non_deleted.unread
  end

end
