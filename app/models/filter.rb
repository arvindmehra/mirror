class Filter < ActiveRecord::Base

  def get_scope_users
    s = User.where("auth_token_created_at < DATE_SUB(NOW(), INTERVAL 1 DAY)")
    s.count
  end


  LIST_KEYS = {
    "numeric_operator_list" => "Numeric Operator List",
    "text_operator_list" => "Text Operator List",
    "recency_list" => "Recency List",
    "merge_fields_list" => "Merge Fields List",
    "cta_list" => "CTA List",
    "product_list" => "Product List",
    "version_list" => "Version List",
    "in_app_purchase_list" => "In-App Purchase List",
    "pre_defined_time_period" => "Pre_defined time period",
    "suburb_visit_recency" => "Suburb visit recency",
    "suburb_visit_frequency" => "Suburb visit frequency",
    "category_list" => "Category List",
    "feeling_score_list" => "Feeling score List",
    "impact_score_list" => "Impact score List",
    "well_being_score_list" => "Well-being score List",
    "occurrences_for_each_topic_list" =>  "Occurrences for each topic list",
    "condition_list" => "Condition list",
    "label_list" => "Label List",
    "future_date_list" => "Future date list",
    "distance_list" => "Distance list",
    "time_operator_list" => "Time operator list",
    "time_of_the_day_list" => "Time of the day list",
    "duration_list" => "Duration List",
    "elapse_time_list" => "Elapse time list",
    "recurrence_time_period_list" => "Recurrence time period List",
    "already_targeted_times_list" => "Already targeted times list",
    "useful_list" => "Useful List",
    "group_list" => "Group List"
  }

  IN = "in"
  LESS_THAN = "<"
  LESS_THAN_OR_EQUAL_TO = "<="
  MORE_THAN = ">"
  MORE_THAN_OR_EQUAL_TO = ">="
  EQUAL_TO = "="
  BETWEEN_OP = "between"
  RELATION_OPERATOR = [LESS_THAN,LESS_THAN_OR_EQUAL_TO,MORE_THAN,MORE_THAN_OR_EQUAL_TO,EQUAL_TO,BETWEEN_OP,IN]
  NON_RELATION_OPERATOR = ["yes","no"]

  KEY_OPERATORS = {
  	"numeric_operator_list" => RELATION_OPERATOR
  }


end
