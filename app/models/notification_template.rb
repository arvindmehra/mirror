class NotificationTemplate < ActiveRecord::Base

	belongs_to :rule_engine

	 CTA = [["Reflect", "reflect"],
          ["Create a note","create_a_note"],
          ["Convert to a note","convert_to_a_note"],
          ["Provide feedback","provide_feedback"],
          ["Set a new goal","set_a_new_goal"],
          ["Subscribe","subscribed"],
          ["Chat with Alex","chat_with_alexs"],
          ["Upgrade to new version","upgrate_to_a_new_version"]
        ]

  CATEGORY = [["Activity","activity"],
              ["Behaviour","behaviour"],
              ["User","user"]
              ]

  def get_scope_users
    users = rule_engine.get_scope_users
  end

  def trigger
    text = title << " " << description
    get_scope_users.each_slice(100) do | batch |
      batch.each do | user |
        devices = user.devices.where.not("notification_token"=>nil)
        devices.each do |device|
          PushNotification.notify_ios(text,device.notification_token)
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
