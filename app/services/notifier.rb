class Notifier

  def self.trigger_for_batch(notification_template)
    Rails.logger.info  "Batch Notification Triggered"
    if notification_template.present?
      if notification_template.merge_field.present?
        send_push_with_merge_fields(notification_template)
      else
        send_push_without_merge_fields(notification_template)
      end
    end
  end

  def self.construct_user_notifications(notification_template,user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      notification_template.user_notifications.build.tap do |user_notification|
        user_notification.title = notification_template.title
        user_notification.subtitle = notification_template.subtitle
        user_notification.description = notification_template.description
        user_notification.merge_field = notification_template.merge_field
        user_notification.cta = notification_template.cta
        user_notification.cta_key = notification_template.cta_key
        user_notification.secondary_cta = notification_template.secondary_cta
        user_notification.secondary_cta_key = notification_template.secondary_cta_key
        user_notification.useful = notification_template.useful
        user_notification.category = notification_template.category
        user_notification.display_screen = notification_template.display_screen
        user_notification.sent_at = Time.current
        user_notification.user_id = user_id
        user_notification.filter_preferences = notification_template.filter_preferences
        user_notification.save
      end
    end
  end

  def self.send_push_without_merge_fields(notification_template)
    text = notification_template.title
    text += " " + notification_template.description
    scope_users = notification_template.get_scope_users
    scope_users = scope_users.is_a?(Hash) ? scope_users[:user_ids] : scope_users
    users = User.where(id: scope_users).includes(:devices)
    if users.present?
      users.each_slice(100) do | batch |
        batch.each do |user|
          construct_user_notifications(notification_template,user.id)
          badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
          devices = user.devices.where.not("notification_token"=>nil)
          if devices.present?
            devices.each do |device|
              PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
              Rails.logger.info  "Sending push to user_id #{user.id} token #{device.notification_token}"
            end
          end
        end
      end
    end
  end

  # GET merge field values from MergeField.get_user_field_values and renders the message using Mustache.renders
  def self.send_push_with_merge_fields(notification_template)
    scope_users = notification_template.get_scope_users
    scope_users = scope_users.is_a?(Hash) ? scope_users[:user_ids] : scope_users
    users = MergeField.get_user_field_values(notification_template.merge_field,scope_users)
    if users.present?
      users.each_slice(100) do |user_record|
        user_record = user_record.first
        user = User.find_by(id: user_record.user_id)
        text = notification_template.title
        notification_template.description = MustacheDescription.render(notification_template,user_record)
        text += " " + notification_template.description
        Rails.logger.info  "Merge field message: #{notification_template.description}"
        construct_user_notifications(notification_template,user_record.user_id)
        badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
        devices = user.devices.with_notification_token
        if devices.present?
          devices.each do |device|
            PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
            Rails.logger.info  "Sending push to user_id #{user_record.user_id} token #{device.notification_token}"
          end
        end
      end
    end
  end

  def self.trigger_for_realtime(notification_template,user)
    Rails.logger.info  "RealTime Notification Triggered"
    text = notification_template.title
    if notification_template.merge_field.present?
      user_fields = MergeField.get_user_field_values(notification_template.merge_field,[user.id])
      notification_template.description = MustacheDescription.render(notification_template,user_fields.first)
      Rails.logger.info  "RealTime Merge field message: #{notification_template.description}"
      text += " " + notification_template.description
    else
      text += " " + notification_template.description
    end
    construct_user_notifications(notification_template,user.id)
    badge = (notification_template.display_screen == "suggestion") ? user.unread_suggestion_notifications.count : user.unread_option_notifications.count
    devices = user.devices.where.not("notification_token"=>nil)
    if devices
      devices.each do |device|
        PushNotification.notify_ios(text,device.notification_token,badge,{screen: notification_template.display_screen})
        Rails.logger.info  "Sending push to user_id #{user.id} token #{device.notification_token}" 
      end
    end 
  end

end