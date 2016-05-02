class V1::UserNotificationsController < V1::BaseController
  before_action :require_user
  before_action :set_notification, except: [:get_all, :get_unread_count]

  def get_all
    landmark = params[:landmark]
    notifications = UserNotification.notification_response(@current_user,landmark)
    render json: notifications
    mark_notifications_read(notifications)
  end

  def get_unread_count
    render json: UserNotification.unread_notification_response_count(@current_user)
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

  def mark_notifications_read(notifications)
    notifications.values.each do |notification_records|
      notification_records.each do |notification|
        notification.read_status = true
        notification.save
      end
    end
  end


  private

  def set_notification
    @notification = UserNotification.find_by(id: params[:id])
    if @notification.user != @current_user
      head :unauthorized
    end
  end
end 