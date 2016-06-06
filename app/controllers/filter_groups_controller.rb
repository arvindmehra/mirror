class FilterGroupsController < ApplicationController
  layout 'cms_layout'

  def index 
    @filter_groups = FilterGroup.all
  end

  def create
    filter_parameters = filter_group_params
    @filter_group = FilterGroup.new(filter_parameters)
    if filter_parameters.present? || !filter_parameters.nil?
      expression = filter_parameters["filter_series"]
      @filter_group.expression = expression.join.strip.gsub(" "," OR ") if expression.present?
      @filter_group.save if @filter_group.expression.present?
      redirect_to filter_groups_path
    end
  end

  def show
    @filter_group = FilterGroup.find_by(id: params[:id])
  end

  def edit
    @filter_group = FilterGroup.find_by(id: params[:id])
  end

  def update
    @filter_group = FilterGroup.find_by(id: params[:id])
    filter_parameters = filter_group_params
    if filter_parameters.present? || !filter_parameters.nil?
      expression = filter_parameters["filter_series"]
      debugger
      @filter_group.expression = expression.join.strip.gsub(" "," OR ") if expression.present?
      @filter_group.save if @filter_group.expression.present?
       flash[:success] = "Updated!!"
      redirect_to filter_groups_path
    else
      redirect_to filter_groups_path
    end
  end

  def new
    @filter_group = FilterGroup.new
    @filters_list = Filter.all
  end

  def destroy
    @filter_group = FilterGroup.find(params[:id])
    if @filter_group.destroy
      flash[:success] = "Thrown to Trash.."
    else
      flash[:error] = "Error deleting Notification"
    end
    redirect_to filter_groups_path
  end

  def duplicate_me
    group = FilterGroup.find_by(id: params[:id])
    new_group = group.dup
    new_group.name = "Duplicate " + group.name
    if new_group.save
      flash[:success] = "Done!!"
      redirect_to filter_groups_path
    else
      flash[:danger] = "oh oh something not right!!"
      redirect_to filter_groups_path
    end
  end

  private

  def filter_group_params
    params.require(:filter_group).permit(:name, :filter_series => [])
  end

end
