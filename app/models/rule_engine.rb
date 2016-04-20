class RuleEngine < ActiveRecord::Base
	attr_accessor :conditional_operator
  attr_accessor :filter_one
  attr_accessor :filter_two
end
