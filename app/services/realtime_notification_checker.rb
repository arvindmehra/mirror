class RealtimeNotificationChecker
  include SuckerPunch::Job

  def perform(note_id)
    user_note = Note.find_by(id: note_id)
    if user_note.present?
      realtime_notification_templates = NotificationTemplate.realtime.alive
      if realtime_notification_templates.present?
        realtime_notification_templates.each do |template|
          condition = template.condition_met
          process_condition(condition,user_note.user,template)
        end
      end
    end
  end

  def process_condition(condition,user,template)
    if condition == "goal_reached"
      if user.achieved_activity_target? && user.is_in_filter_scope?(template)
        Notifier.trigger_for_realtime(template,user)
      end
    end
  end

end