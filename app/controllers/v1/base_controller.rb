class V1::BaseController < ApplicationController
  
  protect_from_forgery with: :null_session
  before_action :set_device
  before_action :set_namespace
  before_action :set_user
  before_action :require_user
  # add to necessary controllers => skip_before_action :require_user

  private

  def set_device
    unless request.headers['device-vendor-id'] && request.headers['device-platform'] && request.headers['location-enabled']
      render json: {errors: ["Device vendor ID,Platform and location setting required!"]}, status: 400
    end

    @current_device = Device.find_or_create_by(vendor_id: request.headers['device-vendor-id'], platform: request.headers['device-platform'])

    unless @current_device.update(location_enabled: request.headers['location-enabled'])
      render json: {errors: ["Device failed to save"]}, status: :unprocessable_entity
    end
  end

  def set_user
    if token = request.headers['user-auth-token']
      @current_user = User.find_by(auth_token: token)
      if @current_user
        @current_device.update(user: @current_user)
        @current_user.update(last_activity: Time.now)
      end
    end
  end

  def require_user
    head :unauthorized unless @current_user
  end

  def set_namespace
    @namespace = "v1"
  end

end
