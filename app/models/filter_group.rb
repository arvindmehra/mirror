class FilterGroup < ActiveRecord::Base

  attr_accessor :conditional_operator_one
  attr_accessor :conditional_operator_two
  attr_accessor :conditional_operator_three
  attr_accessor :conditional_operator_four
  attr_accessor :filter_one
  attr_accessor :filter_two
  attr_accessor :filter_three
  attr_accessor :filter_four
  attr_accessor :filter_five

  
  def get_scope_users
    unwind_expression
  end

  def self.scope_users(query_exp=nil)
    unwind_query_expression(query_exp)
  end

  def unwind_expression
    if expression.present?
      exp = expression.gsub('Filter_', '').gsub('AND', '&').gsub('OR', '|').split
      users = Filter.find(exp.shift).get_scope_users
      while exp.any?
        operator = exp.shift
        next_users = Filter.find(exp.shift).get_scope_users
        users = users.send(operator, next_users)
      end
      users
    end
  end

  def self.unwind_query_expression(query_exp=nil)
    if query_exp.present?
      exp = query_exp.gsub('Filter_', '').gsub('AND', '&').gsub('OR', '|').split
      users = Filter.find(exp.shift).get_scope_users
      while exp.any?
        operator = exp.shift
        next_users = Filter.find(exp.shift).get_scope_users
        users = users.send(operator, next_users)
      end
      users
    end
  end

  def readable_expression
    unwind_expression
    filter1 = Filter.find(@fid1).name
    filter2 = Filter.find(@fid2).name
    "#{filter1} #{@operator} #{filter2} "
  end

end