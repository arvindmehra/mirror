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
    params.require(:notification_template).permit(:title, :subtitle, :description, :merge_field,:cta,:useful, :rule_engine_id, :execution_type, :start_date, :end_date, :active, :category, :cta_key, :display_screen)
  end

end
