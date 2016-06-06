class NotificationTemplatesController < ApplicationController

  layout 'cms_layout'

  def index
    @notifications = NotificationTemplate.all.includes(:rule_engine)
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
    temp_params = notification_params
    @notification_template = NotificationTemplate.find_by(id: params[:id])
    temp_params[:start_date] = Date.strptime(temp_params[:start_date], '%m/%d/%Y') if temp_params[:start_date].present?
    temp_params[:end_date] = Date.strptime(temp_params[:end_date], '%m/%d/%Y') if temp_params[:start_date].present?
    @notification_template.update(temp_params)
    redirect_to notification_templates_path
  end

  def create
    temp_params = notification_params
    temp_params["score_data"] = temp_params["score_data"].strip.gsub(" ","") if temp_params["score_data"].present?
    temp_params[:start_date] = Date.strptime(temp_params[:start_date], '%m/%d/%Y') if temp_params[:start_date].present?
    temp_params[:end_date] = Date.strptime(temp_params[:end_date], '%m/%d/%Y') if temp_params[:start_date].present?
    @notification_template = NotificationTemplate.new(temp_params)
    @notification_template.cta = NotificationTemplate::CTA[temp_params[:cta_key]]
    @notification_template.secondary_cta = NotificationTemplate::CTA[temp_params[:secondary_cta_key]]
    if @notification_template.save
      flash[:success] = "New Notification Created. Superb!!"
      redirect_to notification_templates_path
    end
  end

  def destroy
    @notification_template = NotificationTemplate.find(params[:id])
    if @notification_template.destroy
      flash[:success] = "Thrown to Trash.."
    else
      flash[:error] = "Error deleting Notification"
    end
    redirect_to notification_templates_path
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

  def duplicate_me
    notification = NotificationTemplate.find_by(id: params[:id])
    new_notification = notification.dup
    new_notification.title = "Duplicate " + notification.title
    if new_notification.save
      flash[:success] = "Done!!"
      redirect_to notification_templates_path
    end
  end

  def merge_fields_keys
  end

private
    
  def notification_params
    params.require(:notification_template).permit(:title, :subtitle, :description,
                  :cta,:useful, :rule_engine_id,:execution_type, :start_date, :end_date, :active,
                  :category, :cta_key, :display_screen,:trigger,:time_elapse,:filter_preferences,:merge_field,
                  :elapse_time, :weather, :dashboard, :days_from_now, :topic, :score_data, :heart_rate_min,
                  :heart_rate_medium, :heart_rate_max, :steps_walked_min, :steps_walked_medium, :steps_walked_max,
                  :sleep_time_min, :sleep_time_medium, :sleep_time_max, :temperature_min, :temperature_medium,
                  :chat_email, :provide_feedback_email, :learn_more_url, :take_the_survey_url, :anonymous_feedback_url,
                  [:autofocus_categories => []],:show_useful, :temperature_max,:well_being,
                  :topics, [:weather=> []], :calories_min, :calories_medium, :calories_max,:list_type,
                  :in_exclusion_operator,:in_exclusion_segment,:in_exclusion_condition,:in_exclusion_notification_id,
                  :recurring,:scheduled_time,:secondary_cta_key,:secondary_provide_feedback_email, :secondary_chat_email,
                  :secondary_learn_more_url,:secondary_take_the_survey_url,:secondary_anonymous_feedback_url,:recurring_every)
  end

end
