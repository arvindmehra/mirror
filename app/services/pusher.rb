class Pusher
  include SuckerPunch::Job

  def perform(notification_template_id)
    notification_template = NotificationTemplate.find_by(id: notification_template_id)
    Notifier.trigger_for_batch(notification_template)
  end

end

