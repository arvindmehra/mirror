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

  private

  def device_params
    params.require(:device).permit(:notification_token, :location_enabled, :locale)
  end

end
