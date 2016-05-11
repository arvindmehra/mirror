class UserNotification < ActiveRecord::Base

  include SerialPreference::HasSerialPreferences

  belongs_to :user
  belongs_to :notification_template
  scope :read, -> { where(read_status: 1) }
  scope :unread, -> { where("read_status is ? or read_status = ?",nil,0) }
  scope :non_deleted, -> { where("mark_deleted is ? or mark_deleted = ?",nil,0) }
  scope :for_option_screen, -> { where(display_screen: :option).order(:created_at => :desc) }
  scope :for_suggestion_screen, -> { where(display_screen: :suggestion).order(:created_at => :desc) }

  preferences(:filter_preferences) do
    boolean :well_being
    string :categories
    string :dashboard
    string :days_from_now
    string :topics
    string :score_data
    string :heart_rate_min
    string :heart_rate_max
    string :heart_rate_medium
    string :steps_walked_min
    string :steps_walked_medium
    string :steps_walked_max
    string :sleep_time_min
    string :sleep_time_medium
    string :sleep_time_max
    string :weather
    string :temperature_min
    string :temperature_medium
    string :temperature_max
    string :calories_min
    string :calories_medium
    string :calories_max
    string :provide_feedback_email
    string :chat_email
    string :learn_more_url
    string :take_the_survey_url
    string :anonymous_feedback_url
  end


  def self.notification_response(current_user,landmark=nil)
    response_hash  = {}
    response_hash[:option_notifications] = option_notifications(current_user)
    response_hash[:suggestion_notifications] = self.suggestion_notifications_hash(current_user,landmark)
    response_hash
  end

  def self.option_notifications(current_user)
    current_user.user_notifications.for_option_screen.limit(3).non_deleted
  end

  def self.suggestion_notifications(current_user,landmark=nil)
    landmark.present? ? current_user.user_notifications.for_suggestion_screen.non_deleted.where("id > ?",landmark) : current_user.user_notifications.for_suggestion_screen.non_deleted
  end

  def self.unread_notification_response_count(current_user)
    response_hash  = {}
    response_hash[:option_notifications_count] = UserNotification.option_notifications(current_user).unread.count
    response_hash[:suggestion_notifications_count] = UserNotification.suggestion_notifications(current_user).unread.count
    response_hash
  end

  def self.suggestion_notifications_hash(current_user,landmark)
    suggestion_notifications(current_user,landmark).map do |notification|
      notification.data_hash
    end
  end

  def data_hash
    score_data = self.score_data.split(",") if self.score_data.present?
    categories = self.categories.split(",") if self.categories.present?
    wheather = self.weather.split(",") if self.weather.present?
    topics = self.topics.split(",") if self.topics.present?
    {
      id: self.id,
      title: self.title,
      subtitle: self.subtitle,
      description: self.description,
      cta: self.cta,
      cta_key: self.cta_key,
      category: self.category,
      display_screen: self.display_screen,
      read_status: self.read_status,
      useful: self.useful,
      mark_deleted: self.mark_deleted,
      sent_at: self.sent_at,
      created_at: self.created_at,
      dashboard_screen: self.dashboard,
      wbs: self.well_being,
      provide_feedback_email: self.provide_feedback_email,
      chat_email: self.chat_email,
      learn_more_url: self.learn_more_url,
      take_the_survey_url: self.take_the_survey_url,
      anonymous_feedback_url: self.anonymous_feedback_url,
      filter: {
        days_from_now: self.days_from_now,
        topics: topics,
        score_data: score_data,
        categories: categories,
        weather: weather,
        steps_walked: {
                      min: self.steps_walked_min,
                      medium: self.steps_walked_medium,
                      max: self.steps_walked_max,
                    },
        heart_rate: {
                    min: self.heart_rate_min,
                    medium: self.heart_rate_medium,
                    max: self.heart_rate_max,
                  },
        temperature: {
                  min: self.temperature_min,
                  medium: self.temperature_medium,
                  max: self.temperature_max,
                },
        calories: {
                  min: self.calories_min,
                  medium: self.calories_medium,
                  max: self.calories_max,
                }
          }
    }

  end

end
