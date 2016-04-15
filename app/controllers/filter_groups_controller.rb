class FilterGroupsController < ApplicationController
  layout 'cms_layout'

  def index 
    @filter_groups = FilterGroup.all
  end

  def create
    @filter_group = FilterGroup.new(filter_group_params)
    @filter_group.expression = filter_group_params[:filter_one]
    @filter_group.expression << " " << filter_group_params[:conditional_operator]
    @filter_group.expression << " " <<  filter_group_params[:filter_two]
    @filter_group.save
    redirect_to filter_groups_path
  end

  def show
    @filter_group = FilterGroup.find(params[:id])
  end

  def new
    @filter_group = FilterGroup.new
    @filters_list = Filter.all
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def filter_group_params
    params.require(:filter_group).permit(:name, :filter_one, :filter_two, :conditional_operator)
  end

end
