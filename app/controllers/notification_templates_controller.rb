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

  def create
    @notification_template = NotificationTemplate.new(notification_params)
    @notification_template.cta = NotificationTemplate::CTA[notification_params[:cta_key]]
    if @notification_template.save
      redirect_to notification_templates_path
    end
  end

  def blast_send
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.trigger
    redirect_to notification_template_path(notification)
  end

  def deactivate
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.deactivate
    redirect_to notification_templates_path
  end

  def activate
    notification = NotificationTemplate.find_by(id: params[:id])
    notification.activate
    redirect_to notification_templates_path
  end

private
    
  def notification_params
    params.require(:notification_template).permit(:title, :subtitle, :description,
                  :cta,:useful, :rule_engine_id,:execution_type, :start_date, :end_date, :active,
                  :category, :cta_key, :display_screen,:condition_met,:time_elapse,:filter_preferences,
                  :elapse_time, :whether, :dashboard, :days_from_now, :topic, :score_data, :heart_rate_min,
                  :heart_rate_medium, :heart_rate_max, :steps_walked_min, :steps_walked_medium, :steps_walked_max,
                  :sleep_time_min, :sleep_time_medium, :sleep_time_max, :temperature_min, :temperature_medium, :temperature_max)
  end

end
