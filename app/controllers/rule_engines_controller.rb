class RuleEnginesController < ApplicationController

	layout 'cms_layout'

	def index 
    @rules = RuleEngine.all
  end

  def create
    @rule = RuleEngine.new(rule_params)
    @rule.expression = rule_params[:filter_one]
    @rule.expression << " " << rule_params[:conditional_operator]
    @rule.expression << " " <<  rule_params[:filter_two]
    @rule.save
    redirect_to rule_engines_path
  end

  def show
    @rule = RuleEngine.find(params[:id])
  end

  def new
    @rule = RuleEngine.new
    @filters_list = FilterGroup.all
  end

  private

  def rule_params
    params.require(:rule_engine).permit(:name, :filter_one, :filter_two, :conditional_operator)
  end

end
