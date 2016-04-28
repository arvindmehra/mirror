class RuleEngine < ActiveRecord::Base
	attr_accessor :conditional_operator_one
  attr_accessor :conditional_operator_two
  attr_accessor :filter_one
  attr_accessor :filter_two
  attr_accessor :group_one
  attr_accessor :group_two

  has_many :notification_templates

  def get_scope_users
    expression = convert_groups_to_filters
    FilterGroup.scope_users(expression)
  end


  def convert_groups_to_filters
    expressions = expression.split
    query_exp = []
    expressions.each do |x|
      if x.include?("Group")
        group_id = x.split("_").last
        x = FilterGroup.find(group_id).expression.split
      end
     query_exp << x 
    end
    query_exp.flatten.join(" ")
  end

end
