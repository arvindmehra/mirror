class RealtimeNotificationChecker
  include SuckerPunch::Job

  def self.performer(user_id,trigger)
    target_user = User.find_by(id: user_id)
    if trigger == "note_created"
      realtime_notification_templates = NotificationTemplate.realtime.alive.for_notes 
    elsif trigger == "activity_recorded"
      realtime_notification_templates = NotificationTemplate.realtime.alive.for_activity
    end
    if realtime_notification_templates.present?
      realtime_notification_templates.each do |template|
        perform_in(template.elapse_time,target_user,template)
      end
    end
  end

  def perform(user,template)
    if user.is_in_filter_scope?(template) 
      Notifier.trigger_for_realtime(template,user)
    end
  end

end