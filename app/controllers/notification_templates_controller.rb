class NotificationTemplatesController < ApplicationController

  layout 'cms_layout'

  def index
    @notifications = NotificationTemplate.all
  end

  def show
  end

  def new
    @notification_template = NotificationTemplate.new
  end

  def create
    @notification_template = NotificationTemplate.new(notification_params)
    if @notification_template.save
      redirect_to notification_templates_path 
    end
  end

private
    
  def notification_params
    params.require(:notification_template).permit(:title, :subtitle, :description, :merge_field,:cta,:useful, :rule_engine_id, :execution_type, :start_date, :end_date, :active)
  end

end
