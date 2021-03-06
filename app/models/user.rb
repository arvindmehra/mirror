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
  before_create :set_activity_goal

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

  def todays_activity_time(date=nil)
    today_date = date.present? ? date : Time.current.strftime("%Y-%m-%d")
    activity_for_today = user_activities.where(activity_date: today_date)
    activity_for_today.present? ? activity_for_today.first.time_spent : 0
  end

  def achieved_activity_target?
    targeted_time = activity_goal || 0
    todays_activity_time > targeted_time
  end

  def is_in_filter_scope?(notification_template)
    filter_scoped_users = notification_template.get_scope_users
    filter_scoped_users.include?(self.id)
  end

  def set_activity_goal
    self.activity_goal = 3
  end

  def self.populate_user_records(records)
    ActiveRecord::Base.connection.execute("TRUNCATE temp_user_records")
    ActiveRecord::Base.connection.execute(
                          "INSERT INTO temp_user_records
                          (user_id,goal,time_spent,activity_date)
                          #{records}")
  end

  def self.populate_temp_user_notes
    ActiveRecord::Base.connection.execute(
                          "INSERT INTO temp_user_notes
                                  ( user_id,
                                    encrypted_email,
                                    last_activity,
                                    activity_goal,
                                    auth_token_created_at,
                                    region,
                                    language,
                                    version_number,
                                    version_number_updated_at,
                                    time_zone,
                                    notes_id,
                                    category,
                                    impact,
                                    feeling,
                                    impact_score,
                                    feeling_score,
                                    city,
                                    suburb,
                                    country,
                                    heart_rate,
                                    sleep_time,
                                    temperature,
                                    whether_type,
                                    steps_walked,
                                    calories_burnt,
                                    perception_score,
                                    notes_recorded_at
                                  )
                              SELECT
                              users.id,
                              users.encrypted_email,
                              users.last_activity,
                              users.activity_goal,
                              users.auth_token_created_at,
                              users.region,
                              users.language,
                              users.version_number,
                              users.version_number_updated_at,
                              users.time_zone,
                              notes.id,
                              notes.category,
                              notes.impact,
                              notes.feeling,
                              notes.impact_score,
                              notes.feeling_score,
                              notes.city,
                              notes.suburb,
                              notes.country,
                              notes.heart_rate,
                              notes.sleep_time,
                              notes.temperature,
                              notes.whether_type,
                              notes.steps_walked,
                              notes.calories_burnt,
                              notes.perception_score,
                              notes.recorded_at
                          FROM users LEFT JOIN notes ON users.id = notes.user_id")
  end

end
