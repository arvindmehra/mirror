class V1::UserNotificationsController < V1::BaseController
  before_action :require_user
  before_action :set_notification, except: [:get_all, :get_unread_count]

  def get_all
    landmark = params[:landmark]
    #notifications = UserNotification.non_deleted #temp for demo purpose use below line after demo
    # notifications = @current_user.user_notifications.unread
    render json: UserNotification.notification_response(landmark)
  end

  def get_unread_count
     #temp for demo purpose use below line after demo
    # unread_notifications = @current_user.user_notifications.unread.count
    render json: UserNotification.unread_notification_response_count
  end

  def update
    @notification.mark_deleted = params[:mark_deleted] if params[:mark_deleted].present?
    @notification.useful = params[:useful] if params[:useful].present?
    if @notification.save
       render :json => {:success => true}
    else
      render :json => []
    end
  end


  private

  def set_notification
    @notification = UserNotification.find(params[:id])
    # if @notification.user != @current_user
    #   head :unauthorized
    # end
  end
end 