class Pusher
  include SuckerPunch::Job

  def perform(notification_template_id)
    notification_template = NotificationTemplate.find_by(id: notification_template_id)
    if notification_template.present?
      text = notification_template.title << " " << notification_template.description
      notification_template.get_scope_users.each_slice(100) do | batch |
        batch.each do | user |
          notification_template.user_notifications.build.tap do |user_notification|
            user_notification.title = notification_template.title
            user_notification.subtitle = notification_template.subtitle
            user_notification.description = notification_template.description
            user_notification.merge_field = notification_template.merge_field
            user_notification.cta = notification_template.cta
            user_notification.cta_key = notification_template.cta_key
            user_notification.useful = notification_template.useful
            user_notification.category = notification_template.category
            user_notification.display_screen = notification_template.display_screen
            user_notification.sent_at = Time.current
            user_notification.user_id = user.id
            user_notification.save
          end
          badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
          devices = user.devices.where.not("notification_token"=>nil)
          devices.each do |device|
            PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
            logger.debug  "Sending push to user_id #{user.id} token #{device.notification_token}" 
          end
        end
      end
    end
  end
end