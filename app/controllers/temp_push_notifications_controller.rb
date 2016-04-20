class TempPushNotificationsController < ApplicationController

  def get_push
    text = params[:text]
    token = params[:token]
    data = {}
    data[:screen] = params[:screen]
    PushNotification.notify_ios(text,token,data)
    render json: {success: :ok}
  end

end
