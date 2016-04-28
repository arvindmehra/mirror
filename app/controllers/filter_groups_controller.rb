class FilterGroupsController < ApplicationController
  layout 'cms_layout'

  def index 
    @filter_groups = FilterGroup.all
  end

  def create
    @filter_group = FilterGroup.new(filter_group_params)
    expression = filter_group_params.reject{|k,v| v.blank? || k == "name"}
    @filter_group.expression = expression.values.join
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
    params.require(:filter_group).permit(:name, :filter_one,:conditional_operator_one, :filter_two,:conditional_operator_two,:filter_three,:conditional_operator_three,:filter_four,:conditional_operator_four,:filter_five)
  end

end
