class FiltersController < ApplicationController
  before_filter :authenticate
  layout 'cms_layout'

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'vikash' && password == 'vikash'
    end
  end

  def index
    @filters = Filter.all
  end

  def show
    filter = Filter.find(params[:id])
    @users = filter.get_scope_users if filter.present?
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

  private

  def filter_params
    params.require(:filter).permit(:name, :family, :filter_type, :segment, :operator, :condition,:list_type)
  end

end