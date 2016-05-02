class RuleEnginesController < ApplicationController

	layout 'cms_layout'

	def index 
    @rules = RuleEngine.all
  end

  def create
    @rule = RuleEngine.new(rule_params)
    if rule_params.present? || !rule_params.nil?
      rules = rule_params.reject{|k,v| v.blank? || k == "name"}
      @rule.expression = rules.values.join if rules.present?
      @rule.save if @rule.expression.present?
    end
    redirect_to rule_engines_path
  end

  def show
    @rule = RuleEngine.find_by(id: params[:id])
  end

  def new
    @rule = RuleEngine.new
    @filters_list = FilterGroup.all
  end

  private

  def rule_params
    params.require(:rule_engine).permit(:name, :filter_one, :conditional_operator_one, :group_one,:conditional_operator_two,:group_two)
  end

end
