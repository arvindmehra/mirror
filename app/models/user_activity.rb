class UserActivity < ActiveRecord::Base

  belongs_to :user
  scope :active_time, -> (range) {where(activity_date: range)}

  after_save :check_for_realtime_notifications


  def check_for_realtime_notifications
  	RealtimeNotificationChecker.performer(user.id,"activity_recorded")
  end

end
