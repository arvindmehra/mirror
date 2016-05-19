class DailyNotificationChecker

  def self.send_notifications
    get_alive_notifications
  end

  def self.get_alive_notifications
    notifications = NotificationTemplate.alive.batch
    notifications.each do |nt|
      # time = (nt.scheduled_time - Time.current) * 60
      BatchNotifier.perform_in(5,nt)
    end
  end

end