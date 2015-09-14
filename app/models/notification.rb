class Notification

  def self.ios_pusher
    Grocer.pusher(certificate: "#{Rails.root}/config/apns_cert.pem", passphrase: "paperkite", gateway: "gateway.sandbox.push.apple.com")
  end

end