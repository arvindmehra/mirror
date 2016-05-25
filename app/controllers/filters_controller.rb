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
    @filter = Filter.new(filter_params)
    if @filter.save
      redirect_to filters_path
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
    params.require(:filter).permit(:name, :family, :filter_type, :segment, :operator, :condition,:list_type, :free_text, :start_date, :end_date)
  end

end