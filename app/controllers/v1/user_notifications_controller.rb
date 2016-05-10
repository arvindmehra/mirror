class V1::UserNotificationsController < V1::BaseController
  before_action :require_user
  before_action :set_notification, except: [:get_all, :get_unread_count,:template]

  def get_all
    landmark = params[:landmark]
    notifications = UserNotification.notification_response(@current_user,landmark)
    render json: notifications
    mark_notifications_read(notifications)
  end

  def template
    render json:
    {
      dashboard_screen: "life_path",
      wbs: 7,
      filter: {
        days_from_now: 4,
        topic: ["worldcup","ipl"],
        score_data: ["3-7","4-7","5-7"],
        categories:["Actions","Discoveries","Experiences","Decisions"],
        whether:["cloudy","overcast"],
        steps_walked: {
                        min: 0,
                        medium: 1,
                        max: 1,
                      },
        heart_rate: {
          min: 0,
          medium: 1,
          max: 1,
        },

        temperature: {
          min: 0,
          medium: 1,
          max: 1,
        },

      }

    }

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