class Filter < ActiveRecord::Base

  def get_scope_users
    @filter = self
    @segment = @filter.segment # downloaded_the_app  
    @list_type = @filter.list_type # recency_list
    @condition = @filter.condition # 12_day_ago
    @operator = @filter.operator # <
    @start_date = @filter.start_date
    @end_date = @filter.end_date
    if @list_type == "recency_list"
      @digit, @hour_day_week = @condition.split("_")
    end
    # begin
      users = send("process_#{@segment}")
      users.count
    # rescue
    #   message = "Filter not Aplicable"
    # end

  end

  def process_downloaded_the_app
    segment_definition = "auth_token_created_at"
    if @condition == "today"
      s = User.where("Date(#{segment_definition}) #{@operator}  DATE(NOW())")
    else
      s = User.where("#{segment_definition} #{@operator} DATE_SUB(NOW(), condition #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_expired_subscription
    s = User.joins(:subscriptions).where("Date(subscriptions.end_date) #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    s
  end

  def process_subscribed_alteast_once
    s = User.joins(:receipts)
    s
  end

  def process_active_subscription
    s = Subscription.where("DATE(@end_date) >= DATE(NOW())")
    s
  end

  def process_expired_subscription
    s = User.joins(:subscriptions).where("Date(subscriptions.end_date) #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    s
  end

  def process_havent_subscribed
    s = users = User.joins(:receipts)
    s = User.where.not(id: users.pluck(:user_id))
    s
  end

   def process_about_to_expire
    s = User.joins(:subscriptions).where("subscriptions.end_date between ? and ?",@start_date ,@end_date)
    s
  end

  def process_categories
    s = User.joins(:notes).where(notes: {category: @condition})
    s
  end

  def process_feeling_score
    s = User.joins(:notes).where("notes.feeling_score #{operator} ?","#{condition}")
    s
  end

  def process_impact_score
    s = User.joins(:notes).where("notes.impact_score #{operator} ?","#{condition}")
    s
  end

  def process_average_feeling_score
  end 

  def process_average_impact_score
  end 

  def process_well_being_score
    s = User.joins(:notes).where("notes.perception_score #{operator} ?","#{condition}")
    s
  end

  def process_average_well_being_score
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

  TEXT_OPERATOR_LIST = {
    "equals_to" => "Equals to",
    "starts_with" => "Starts With",
    "ends_with" => "Ends With",
    "contains" => "Contains"
  }
  

  KEY_OPERATORS = {
    "numeric_operator_list" => RELATION_OPERATOR,
    "text_operator_list" => ["equals_to","starts_with", "ends_with","contains"],
    "recency_list" => ["today",
                          "1_hour_ago",
                          "2_hour_ago",
                          "3_hour_ago",
                          "4_hour_ago",
                          "1_day_ago",
                          "2_day_ago",
                          "3_day_ago",
                          "4_day_ago",
                          "5_day_ago",
                          "6_day_ago",
                          "7_day_ago",
                          "8_day_ago",
                          "9_day_ago",
                          "10_day_ago",
                          "11_day_ago",
                          "12_day_ago",
                          "13_day_ago",
                          "2_week_ago",
                          "3_week_ago",
                          "4_week_ago"
                        ],
    "merge_fields_list" => ["weather_condition",
                            "weather_temperature",
                            "distance_from_last_suburb_visited",
                            "suburb",
                            "state",
                            "heart_rate",
                            "steps",
                            "calories_burned",
                            "sleep_hours",
                            "well_being_score",
                            "feeling_score",
                            "impact_score",
                            "topic",
                            "meeting_datetime",
                            "meetings"],
    "cta_list" => [ "reflect",
                    "create_a_note", 
                    "convert_to_a_note", 
                    "provide_feedback", 
                    "set_a_new_goal", 
                    "rate_the_app", 
                    "subscribe", 
                    "chat_with_alex", 
                    "upgrade_to_new_version"],
    "version_list" => [ "V1.0",
                        "V1.01",
                        "V1.02",
                        "V1.03",
                        "V1.04",
                        "V2.0",
                        "V2.5",
                        "V2.6",
                        "V3.0"],
    "category_list" => ["Experiences","Actions","Emotions","Decisions","Discoveries"],
    "feeling_score_list" => [1,2,3,4,5,6,7,8],
    "impact_score_list" => [1,2,3,4,5,6],
    "well_being_score_list" => [-24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0,
                                 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
    "condition_list" => ["clear",
                          "overcast",
                          "wind",
                          "cloudy",
                          "rain",
                          "thunderstorm",
                          "fog",
                          "snow"]
  }

SEGMENT= [["Downloaded the app", "downloaded_the_app"],
          ["Upgraded the app","upgraded_the_app"],
          ["Last note created","last_note_created"],
          ["Users subscribed atleast once","subscribed_alteast_once"],
          ["Users with active subscription","subscription_active?"],
          ["Users havent yet subscribed","havent_subscribed"],
          ["User with subscription about to expire","about_to_expire"],
          ["User with expired subscription","expired_subscription"],
          ["Categories","categories"],
          ["Feeling score","feeling_score"],
          ["Impact score","impact_score"],
          ["Average Feeling score","average_feeling_score"],
          ["Average Impact score","average_impac_score"],
          ["Well-being score","well_being_score"],
          ["Average Well-being score","average_well_being_score"]

        ]

  def self.drop_down_list(key)
    KEY_OPERATORS[key]
  end

end
