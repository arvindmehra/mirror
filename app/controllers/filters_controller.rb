class FiltersController < ApplicationController
  before_filter :authenticate
  layout 'cms_layout'

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'username' && password == 'password'
    end
  end

  def index
    @filters = Filter.all
  end

  def show
    @filter = Filter.find_by(id: params[:id])
    @users = @filter.get_scope_users if @filter.present?
  end

  def new
    @filter = Filter.new
  end

  def create
    temp_params = filter_params
    temp_params[:start_date] = Date.strptime(temp_params[:start_date], '%m/%d/%Y') if temp_params[:start_date].present?
    temp_params[:end_date] = Date.strptime(temp_params[:end_date], '%m/%d/%Y') if temp_params[:start_date].present?
    @filter = Filter.new(temp_params)
    if @filter.save
      redirect_to filters_path
    else
      flash[:warning] = @filter.errors.messages[:free_text].join
      render :new
    end
  end

  def destroy
    @filter = Filter.find(params[:id])
    if @filter.destroy
      flash[:success] = "Thrown to Trash.."
    else
      flash[:error] = "Error deleting Notification"
    end
    redirect_to filters_path
  end

  def get_list
    @filter_list = Filter.drop_down_list(params[:list_type])
    respond_to do |format|
      format.js
    end
  end

  def get_segments
    @segment_list = Filter.find_segment(params[:list_type])
    respond_to do |format|
      format.js
    end
  end

  def get_collective_list
    @collective_list = params[:list_type]
    respond_to do |format|
      format.js
    end
  end

  private

  def filter_params
    params.require(:filter).permit(:id,  :name, :family, :filter_type, :segment, :operator, :condition,:list_type, :free_text, :start_date, :end_date)
  end

end