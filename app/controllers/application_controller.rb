class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hourly_schedule
    User.send_usage_reminders
    User.send_subscription_reminders
  end

end
