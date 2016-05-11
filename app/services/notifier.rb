class Notifier

  def self.trigger_for_batch(notification_template)
    if notification_template.present?
      text = notification_template.title << " " << notification_template.description
      users = User.where(id: notification_template.get_scope_users).includes(:devices)
      users.each_slice(100) do | batch |
        batch.each do | user |
          construct_user_notifications(notification_template,user)
          badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
          devices = user.devices.where.not("notification_token"=>nil)
          devices.each do |device|
            PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
            Rails.logger.info  "Sending push to user_id #{user.id} token #{device.notification_token}" 
          end
        end
      end
    end
  end

  def self.construct_user_notifications(notification_template,user)
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
      user_notification.filter_preferences = notification_template.filter_preferences
      user_notification.save
    end
  end

  def self.trigger_for_realtime(notification_template,user)
    text = notification_template.title << " " << notification_template.description
    construct_user_notifications(notification_template,user)
    badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
    devices = user.devices.where.not("notification_token"=>nil)
    devices.each do |device|
      PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
      Rails.logger.info  "Sending push to user_id #{user.id} token #{device.notification_token}" 
    end
  end

end