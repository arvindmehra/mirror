class FilterGroup < ActiveRecord::Base

  attr_accessor :conditional_operator
  attr_accessor :filter_one
  attr_accessor :filter_two

  
  def get_scope_users
    unwind_expression
    get_users_from_expression
  end

  def unwind_expression
    exp = self.expression #"Filter_5 OR Filter_7"
    exp = exp.split(" ") #["Filter_5", "OR", "Filter_7"]
    @fid1 = exp[0].split("_").last
    @fid2 = exp[2].split("_").last
    @operator = exp[1]
  end

  def get_users_from_expression
    if @operator == "OR"
      users = (Filter.find(@fid1).get_scope_users) | (Filter.find(@fid2).get_scope_users)
    else
      users = (Filter.find(@fid1).get_scope_users) & (Filter.find(@fid2).get_scope_users)
    end
    users
  end

  def readable_expression
    unwind_expression
    filter1 = Filter.find(@fid1).name
    filter2 = Filter.find(@fid2).name
    "#{filter1} #{@operator} #{filter2} "
  end

end
