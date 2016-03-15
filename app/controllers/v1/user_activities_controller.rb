class V1::UserActivitiesController < V1::BaseController
  before_action :require_user

  def record_activity
    activity_date_params = params.slice(:activity_date1,:activity_date2)
    time_spent_params = params.slice(:activity_date1_time,:activity_date2_time)
    record = activity_date_params.each do |key,value|
      user_activity = @current_user.user_activities.find_or_initialize_by(activity_date: value)
      time_spent = key + "_time"
      user_activity.time_spent = user_activity.time_spent? ? user_activity.time_spent + params[time_spent].to_i : params[time_spent].to_i
      user_activity.save
    end
    if record.present?
      render :json => {status: 200}
    else
      render :json => {errors: "no record created"}
    end
  end

  def active_period
    if params[:begin_date] && params[:end_date]
      user_activities = @current_user.user_activities.active_time(params[:begin_date]..params[:end_date])
      active_time = user_activities.present? ? (user_activities.pluck(:time_spent).sum / user_activities.count) : nil
    end
    if params[:activity_date]
      user_activity = @current_user.user_activities.where(activity_date: params[:activity_date])
      active_time = user_activity.present? ? user_activity.pluck(:time_spent).sum : nil
    end
    render json: {active_time: active_time}
  end

  def keyboard
    render json: { exluded: [{text: "this",language: "french"},{text: "is", language: "eng-us"},{text: "a", language: "french"}],
                  suggested: [{text: "red",language: "french"},{text: "green", language: "eng-us"},{text: "cyan", language: "french"}]
                  }
  end

end
