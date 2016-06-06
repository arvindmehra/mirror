class RuleEnginesController < ApplicationController

  layout 'cms_layout'

  def index
    @rules = RuleEngine.all
  end

  def create
    rule_parameters = rule_params
    @rule = RuleEngine.new(rule_parameters)
    if rule_parameters.present? || !rule_parameters.nil?
      rules = rule_parameters["expression"]
      @rule.expression = rules.join.strip.gsub(" "," AND ") if rules.present?
      @rule.save if @rule.expression.present?
      flash[:success] = "New Rule Created. Bravo!!"
    end
    redirect_to rule_engines_path
  end

  def edit
    @rule = RuleEngine.find_by(id: params[:id])
  end

  def update
    rule_parameters = rule_params
    @rule = RuleEngine.find_by(id: params[:id])
    if rule_parameters.present? || !rule_parameters.nil?
      rules = rule_parameters["expression"]
      @rule.expression = rules.join.strip.gsub(" "," AND ") if rules.present?
      @rule.save if @rule.expression.present?
      flash[:success] = "New Rule Created. Bravo!!"
      redirect_to rule_engines_path
    else
      redirect_to rule_engines_path
    end
  end

  def show
    @rule = RuleEngine.find_by(id: params[:id])
  end

  def new
    @rule = RuleEngine.new
    @filters_list = FilterGroup.all
  end

  def destroy
    @rule = RuleEngine.find(params[:id])
    if @rule.destroy
      flash[:success] = "Thrown to Trash.."
    else
      flash[:error] = "Error deleting Rule"
    end
    redirect_to rule_engines_path
  end

  def duplicate_me
    rule = RuleEngine.find_by(id: params[:id])
    new_rule = rule.dup
    new_rule.name = "Duplicate " + rule.name
    if new_rule.save
      flash[:success] = "Done!!"
      redirect_to rule_engines_path
    end
  end

  private

  def rule_params
    params.require(:rule_engine).permit(:name, expression: [])
  end

end
