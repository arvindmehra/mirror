class V1::UserNotificationsController < V1::BaseController
  before_action :require_user
  before_action :set_notification, except: [:get_all, :get_unread_count]

  def get_all
    notifications = @current_user.user_notifications
    render json: notifications.to_json(:except => ["user_id","admin_notification_id","updated_at"])
  end

  def get_unread_count
    unread_notifications = @current_user.user_notifications.unread.count
    render json: {unread_count: unread_notifications}
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
    if @notification.user != @current_user
      head :unauthorized
    end
  end
end 