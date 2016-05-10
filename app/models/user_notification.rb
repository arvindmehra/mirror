class UserNotification < ActiveRecord::Base

  include SerialPreference::HasSerialPreferences

  belongs_to :user
  belongs_to :notification_template
  scope :read, -> { where(read_status: 1) }
  scope :unread, -> { where("read_status is ? or read_status = ?",nil,0) }
  scope :non_deleted, -> { where("mark_deleted is ? or mark_deleted = ?",nil,0) }
  scope :for_option_screen, -> { where(display_screen: :option).order(:created_at => :desc) }
  scope :for_suggestion_screen, -> { where(display_screen: :suggestion).order(:created_at => :desc) }


  def self.notification_response(current_user,landmark=nil)
    response_hash  = {}
    response_hash[:option_notifications] = option_notifications(current_user)
    response_hash[:suggestion_notifications] = suggestion_notifications(current_user,landmark)
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

end
