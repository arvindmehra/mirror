class NotificationTemplatesController < ApplicationController

  layout 'cms_layout'

  def index
    @notifications = NotificationTemplate.all
  end

  def show
    @notification = NotificationTemplate.find_by(id: params[:id])
  end

  def new
    @notification_template = NotificationTemplate.new
  end

  def edit
    @notification_template = NotificationTemplate.find_by(id: params[:id])
  end

  def update
    @notification_template = NotificationTemplate.find_by(id: params[:id])
    @notification_template.update(notification_params)
    redirect_to notification_templates_path
  end

  def create
    @notification_template = NotificationTemplate.new(notification_params)
    @notification_template.cta = NotificationTemplate::CTA[notification_params[:cta_key]]
    @notification_template.scheduled_time = Time.current + 5
    if @notification_template.save
      flash[:success] = "New Notification Created. Superb!!"
      redirect_to notification_templates_path
    end
  end

  def blast_send
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.fire
    flash[:success] = "Blast Send Triggered. Sit Tight!!"
    redirect_to notification_templates_path
  end

  def deactivate
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.deactivate
    flash[:success] = "Deactivated. Relax!!"
    redirect_to notification_templates_path
  end

  def activate
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.activate
    flash[:success] = "Activated. Careful!"
    redirect_to notification_templates_path
  end

  def get_list
    @filter_list = NotificationTemplate.drop_down_list(params[:list_type])
    respond_to do |format|
      format.js
    end
  end

private
    
  def notification_params
    params.require(:notification_template).permit(:title, :subtitle, :description,
                  :cta,:useful, :rule_engine_id,:execution_type, :start_date, :end_date, :active,
                  :category, :cta_key, :display_screen,:trigger,:time_elapse,:filter_preferences,
                  :elapse_time, :weather, :dashboard, :days_from_now, :topic, :score_data, :heart_rate_min,
                  :heart_rate_medium, :heart_rate_max, :steps_walked_min, :steps_walked_medium, :steps_walked_max,
                  :sleep_time_min, :sleep_time_medium, :sleep_time_max, :temperature_min, :temperature_medium, :temperature_max,
                  :chat_email, :provide_feedback_email, :learn_more_url, :take_the_survey_url, :anonymous_feedback_url,[:autofocus_categories => []],
                  :well_being, :topics, [:weather=> []], :calories_min, :calories_medium, :calories_max,:list_type,
                  :in_exclusion_operator,:in_exclusion_segment,:in_exclusion_condition,:in_exclusion_notification_id,
                  :recurring,:scheduled_time)
  end

end
