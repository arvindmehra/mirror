module UserReminder

  extend ActiveSupport::Concern

  included do
    scope :inactive, -> (number_of_days) {
      where(last_activity: number_of_days.days.ago..(number_of_days.days.ago + 1.hour))
    }
  end
  
  module ClassMethods

    def send_usage_reminders
      ios_pusher = Notification.ios_pusher
      [2, 5, 10, 17, 30, 60, 90].each do |number_of_days|
        User.inactive(number_of_days).each do |user|
          user.devices.each do |device|
            notification = Grocer::Notification.new(
              device_token:      device.notification_token,
              alert:             "Take your time to reflect..",
              badge:             1)
            pusher.push(notification)
          end
        end
      end
    end

    def send_subscription_reminders
      ios_pusher = Notification.ios_pusher
      [3, 5].each do |number_of_days|
        Transaction.expiring_in(number_of_days).each do |transaction|
          if transaction.user.transactions.last == transaction # check if this is the last transaction (user didn't renew yet)
            transaction.user.devices.each do |device|
              notification = Grocer::Notification.new(
                device_token: device.notification_token,
                alert: "Your subscription expires in #{number_of_days} days!",
                badge: 1)
              pusher.push(notification)
            end
          end
        end
      end
    end

  end

end
