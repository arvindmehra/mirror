class NotificationTemplate < ActiveRecord::Base

  has_many :user_notifications
	belongs_to :rule_engine

	 DISPLAY_SCREEN = [["Option", "option"],
                    ["Suggestion","suggestion"]]


    CTA = {"reflect"=>"Reflect", 
          "create_a_note"=>"Create a note", 
          "convert_to_a_note"=>"Convert to a note", 
          "provide_feedback"=>"Provide feedback", 
          "set_a_new_goal"=>"Set a new goal", 
          "subscribed"=>"Subscribe", 
          "chat_with_alexs"=>"Chat with Alex", 
          "upgrate_to_a_new_version"=>"Upgrade to new version"}

  CATEGORY = [["Activity","activity"],
              ["Behaviour","behaviour"],
              ["User","user"]]

  def get_scope_users
    users = rule_engine.get_scope_users
  end

  def trigger
    text = title << " " << description
    get_scope_users.each_slice(100) do | batch |
      batch.each do | user |
        self.user_notifications.build.tap do |user_notification|
          user_notification.title = title
          user_notification.subtitle = subtitle
          user_notification.description = description
          user_notification.merge_field = merge_field
          user_notification.cta = cta
          user_notification.cta_key = cta_key
          user_notification.useful = useful
          user_notification.category = category
          user_notification.display_screen = display_screen
          user_notification.sent_at = Time.current
          user_notification.user_id = user.id
          user_notification.save
        end
        badge = (display_screen == "suggestion") ? user.unread_suggestion_notifications.count : unread_option_notifications.count
        devices = user.devices.where.not("notification_token"=>nil)
        devices.each do |device|
          PushNotification.notify_ios(text,device.notification_token,badge,{screen: display_screen})
          logger.debug  "Sending push to user_id #{user.id} token #{device.notification_token}" 
        end
      end
    end
  end

  def deactivate
    self.active = false
    self.save
  end

  def activate
    self.active = true
    self.save
  end

end
