module UserAuthentication
  extend ActiveSupport::Concern

  included do
    has_secure_password validations: false
    attr_encrypted :email, :key => 'some_key'
    validate :email_must_be_valid
    validate :password_must_be_valid
    before_create :generate_auth_token
    attr_accessor :password_confirmation
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset_mail(self).deliver
  end

  def email_must_be_valid
    return unless email.present?
    errors.add(:base, "Email is invalid.") if email.match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i).nil?
    if user = User.find_by_email(email)
      if user != self
        errors.add(:base, "Email has already been taken.")
      end
    end
  end

  def password_must_be_valid
    if password.present? && email.present?
      if password.length < 6
        errors.add(:base, "Password must have at least 6 characters") 
      end
      # if password.length < 8
      #   errors.add(:base, "Password must have at least 8 characters") 
      # end
      # if password.match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/).nil?
      #   errors.add(:base, "Password must include at least one uppercase letter, one lowercase letter, and one digit")
      # end
    end
  end

  def generate_auth_token
    generate_token(:auth_token)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods
  end

end
