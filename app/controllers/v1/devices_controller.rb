class V1::DevicesController < V1::BaseController

  def update
    if @current_device.update(device_params)
      @device = @current_device
      render :show
    else
      render json: {errors: @device.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @device = @current_device
  end

  def set_notification_token
    if @current_user.present?
      @current_user.devices.each do |device|
        device.notification_token = nil
        device.save!
      end
    end
    set_device
    if @current_device.update(notification_token: params[:notification_token])
      @current_user.update(language: params[:language], region: params[:region], time_zone: params[:time_zone], version_number: params[:version_number])
      @current_user.update(version_number_updated_at: Time.current) if !@current_user.version_number_updated_at.present?
      render :show
    else
      render json: {errors: @current_device.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.require(:device).permit(:notification_token, :location_enabled, :locale, :language, :region, :time_zone, :version_number)
  end

end
