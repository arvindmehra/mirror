class RuleEngine < ActiveRecord::Base
	attr_accessor :conditional_operator_one
  attr_accessor :conditional_operator_two
  attr_accessor :filter_one
  attr_accessor :filter_two
  attr_accessor :group_one
  attr_accessor :group_two

  has_many :notification_templates

  def get_scope_users
    unwind_expression
  end


  def convert_groups_to_filters
    expressions = expression.split
    query_exp = []
    expressions.each do |x|
      if x.include?("Group")
        group_id = x.split("_").last
        x = FilterGroup.find_by(id: group_id).expression.split
      end
     query_exp << x 
    end
    query_exp.flatten.join(" ")
  end

  def unwind_expression
    if self.expression.present?
      exp = expression.gsub('AND', '&').split
      klass_id =  exp.shift
      if klass_id.include?("Group")
        id = klass_id.gsub('Group_', '')
        @users = FilterGroup.find_by(id: id).get_scope_users
      else
        id = klass_id.gsub('Filter_', '')
        @users = Filter.find_by(id: id).get_scope_users
      end
      while exp.any?
        operator = exp.shift
        klass_id = exp.shift
        if klass_id.include?("Group")
          id = klass_id.gsub('Group_', '')
          next_users = FilterGroup.find_by(id: id).get_scope_users
        else
          id = klass_id.gsub('Filter_', '')
          next_users = Filter.find_by(id: id).get_scope_users
        end
        @users = @users.send(operator, next_users)
      end
      @users
    end
  end

end
