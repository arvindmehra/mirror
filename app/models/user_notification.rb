class UserNotification < ActiveRecord::Base

  include SerialPreference::HasSerialPreferences

  belongs_to :user
  belongs_to :notification_template
  scope :read, -> { where(read_status: 1) }
  scope :unread, -> { where("read_status is ? or read_status = ?",nil,0) }
  scope :useful, -> { where(useful: 1) }
  scope :not_useful, -> { where("useful = ?",0) }
  scope :not_commented_on_useful, -> { where("useful is ?",nil) }
  scope :non_deleted, -> { where("mark_deleted is ? or mark_deleted = ?",nil,0) }
  scope :for_option_screen, -> { where(display_screen: :option).order(:created_at => :desc) }
  scope :for_suggestion_screen, -> { where(display_screen: :suggestion).order(:created_at => :desc) }

  preferences(:filter_preferences) do
    boolean :well_being
    string :autofocus_categories
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
    string :secondary_provide_feedback_email
    string :secondary_chat_email
    string :secondary_learn_more_url
    string :secondary_take_the_survey_url
    string :secondary_anonymous_feedback_url
  end


  def self.notification_response(current_user,landmark=nil)
    response_hash  = {}
    response_hash[:option_notifications] = option_notifications_hash(current_user)
    response_hash[:suggestion_notifications] = suggestion_notifications_hash(current_user,landmark)
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

  def self.option_notifications_hash(current_user)
    option_notifications(current_user).map do |notification|
      notification.data_hash
    end
  end

  def data_hash
    score_data = score_data.split(",") if score_data.present?
    categories = JSON.parse(autofocus_categories) if autofocus_categories.present?
    weather = JSON.parse(weather) if weather.present?
    topics = self.topics.split(",").collect(&:strip) if self.topics.present?
    {
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      cta: cta,
      cta_key: cta_key,
      secondary_cta: secondary_cta,
      secondary_cta_key: secondary_cta_key,
      category: category,
      display_screen: display_screen,
      read_status: read_status,
      show_useful: show_useful,
      useful: useful,
      mark_deleted: mark_deleted,
      sent_at: sent_at,
      created_at: created_at,
      dashboard_screen: dashboard,
      wbs: well_being,
      provide_feedback_email: provide_feedback_email,
      chat_email: chat_email,
      learn_more_url: learn_more_url,
      take_the_survey_url: take_the_survey_url,
      anonymous_feedback_url: anonymous_feedback_url,
      secondary_provide_feedback_email: secondary_provide_feedback_email,
      secondary_chat_email: secondary_chat_email,
      secondary_learn_more_url: secondary_learn_more_url,
      secondary_take_the_survey_url: secondary_take_the_survey_url,
      secondary_anonymous_feedback_url: secondary_anonymous_feedback_url,

      filter: {
        days_from_now: days_from_now,
        topics: topics,
        score_data: score_data,
        categories: categories,
        weather: weather,
        steps_walked: {
                      min: steps_walked_min,
                      medium: steps_walked_medium,
                      max: steps_walked_max,
                    },
        heart_rate: {
                    min: heart_rate_min,
                    medium: heart_rate_medium,
                    max: heart_rate_max,
                  },
        temperature: {
                  min: temperature_min,
                  medium: temperature_medium,
                  max: temperature_max,
                },
        calories: {
                  min: calories_min,
                  medium: calories_medium,
                  max: calories_max,
                },
        sleep_time: {
                  min: sleep_time_min,
                  medium: sleep_time_medium,
                  max: sleep_time_max,
                }
          }
    }

  end

end
