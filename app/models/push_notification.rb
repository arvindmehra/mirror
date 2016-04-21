class PushNotification < ActiveRecord::Base

  def self.certificate_convertor(path)
    pn = PushNotification.new
    if Rails.env.production?
      pn.environment = "production"
      pn.ios_certificate =  %x{openssl pkcs12 -nodes -clcerts -in #{path} -password pass:"app123"}
    else
      pn.environment = "development"
      pn.ios_certificate =  %x{openssl pkcs12 -nodes -clcerts -in #{path} -password pass:"app123"}
    end
    pn.save!
  end

  def self.notify_ios(text,token,data=nil)
    apn = Rails.env.development? ? Houston::Client.development : Houston::Client.production
    environment = Rails.env.development? ? "development" : "production"
    apn.certificate = PushNotification.where(environment: environment).first.ios_certificate
    device = Device.find_by(notification_token: token)
    if device.present?
      notification = Houston::Notification.new(device: device.notification_token)
      notification.alert = text
      # take a look at the docs about these params
      notification.badge = 1
      notification.sound = "sosumi.aiff"
      notification.custom_data = data unless data.nil?
      apn.push(notification)
    end
  end
  
end
