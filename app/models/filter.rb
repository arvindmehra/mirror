class Filter < ActiveRecord::Base

  def get_scope_users(group=nil,truncate_table=true)
    prepare_temp_user_note_table if truncate_table
    @filter = self
    @segment = @filter.segment # downloaded_the_app
    @list_type = @filter.list_type # recency_list
    @condition = @filter.condition # 12_day_ago
    @operator = @filter.operator # <
    @start_date = @filter.start_date.strftime("%Y-%m-%d") if !@filter.start_date.nil?
    @end_date = @filter.end_date.strftime("%Y-%m-%d") if !@filter.end_date.nil?
    @free_text = @filter.free_text
    if @list_type == "recency_list" || @list_type == "pre_defined_time_period"
      @digit, @hour_day_week = @condition.split("_")
    elsif @list_type == "future_date_list"
      @in, @digit, @hour_day_week = @condition.split("_")
    end
    # begin
      users = send("process_#{@segment}") 
      if users.is_a?(Hash)
        users
      elsif group.present? && !users.is_a?(Array)
        logger.debug  "plucking user_ids from temp_user_notes" 
        users.pluck(:user_id).uniq
      else
        users.map{|x| x.user_id}.uniq
      end
    # rescue
    #   message = "Filter not Aplicable"
    # end

  end

  def process_weather_condition
    s = TempUserNote.where(whether_type: "#{@condition}")
    s
  end

  def process_downloaded_the_app
    segment_definition = "auth_token_created_at"
    if @condition == "today"
      s = TempUserNote.where("Date(#{segment_definition}) #{@operator}  DATE(NOW())")
    elsif @hour_day_week == "hour"
      s = TempUserNote.where("#{segment_definition} #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      s = TempUserNote.where("DATE(#{segment_definition}) #{@operator} DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_subscribed_alteast_once
    if @condition == "12"
      id = 1
    elsif @condition == "3"
      id = 2
    else
      id = 3
    end
    s = TempUserNote.joins("inner join transactions on transactions.user_id = temp_user_notes.user_id")
    s
  end

  def process_active_subscription
    if @condition == "12"
      id = 1
    elsif @condition == "3"
      id = 2
    else
      id = 3
    end
    s = TempUserNote.joins("inner join transactions on transactions.user_id = temp_user_notes.user_id inner join subscriptions on subscriptions.user_id = temp_user_notes.user_id")
    s = s.where(transactions: {product_id: 2}).where("DATE(subscriptions.end_date) >= CURDATE()")
    s
  end

  def process_expired_subscription
    s = TempUserNote.joins("inner join subscriptions on subscriptions.user_id = temp_user_notes.user_id")
    if @condition == "today"
      s = s.where("end_date between CURDATE() and now()")
    else
      s = s.where("subscriptions.end_date between DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week}) and now()")
    end
    s
  end

  def process_havent_subscribed
    s = users = User.joins(:receipts)
    s = TempUserNote.where.not(id: users.pluck(:user_id).uniq)
    s
  end

  def process_categories
    s = TempUserNote.where(category: "#{@condition}")
    s
  end

  def process_feeling_score
    s = TempUserNote.where("temp_user_notes.feeling_score #{operator} ?","#{condition}")
    s
  end

  def process_impact_score
    s = TempUserNote.where("temp_user_notes.impact_score #{operator} ?","#{condition}")
    s
  end

  def process_average_impact_score
    s = TempUserNote.find_by_sql("select user_avg_table.* from
          (select temp_user_notes.*, avg(impact_score) as avg from temp_user_notes group by user_id)
          as user_avg_table where avg #{@operator} #{@condition}")
    s
  end

  def process_average_feeling_score
    s = TempUserNote.find_by_sql("select user_avg_table.* from
          (select temp_user_notes.*, avg(feeling_score) as avg from temp_user_notes group by user_id)
          as user_avg_table where avg #{@operator} #{@condition}")
    s
  end

  def process_average_well_being_score
    s = TempUserNote.find_by_sql("select user_avg_table.* from
          (select temp_user_notes.*, avg(perception_score) as avg from temp_user_notes group by user_id)
          as user_avg_table where avg #{@operator} #{@condition}")
    s
  end

  def process_well_being_score
    s = TempUserNote.where("temp_user_notes.perception_score #{operator} ?","#{condition}")
    s
  end

  def process_about_to_expire
    s = TempUserNote.joins("inner join subscriptions on subscriptions.user_id = temp_user_notes.user_id")
    if @condition == "today"
      s = s.where("Date(end_date) = CURDATE()")
    elsif @condition == "tomorrow"
      s = s.where("Date(end_date) = DATE_ADD(CURDATE(), INTERVAL 1 Day)")
    else
      s = s.where("subscriptions.end_date between NOW() and DATE_ADD(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_total_notes
    s = TempUserNote.find_by_sql("select unotes.*, user_notes from
        (select temp_user_notes.* , count(notes_id) as user_notes from temp_user_notes group by user_id)
        as unotes where user_notes #{@operator} #{@free_text}")
    s
  end

  def process_last_connection
    s =  TempUserNote.where("Date(last_activity) #{@operator} DATE_SUB(now(), INTERVAL #{@digit} #{@hour_day_week})")
    s
  end

  def process_last_note_created
    s = TempUserNote.where("notes_recorded_at #{@operator} DATE_SUB(now(), INTERVAL #{@digit} #{@hour_day_week})")
    s = {temp_user_notes_ids: s.pluck(:id), user_ids: s.pluck(:user_id).uniq }
    s
  end

  def process_steps
    TempUserNote.where("steps_walked #{@operator} #{@free_text}").uniq
  end

  def process_users_with_account
    s = TempUserNote.where.not(encrypted_email: nil)
    s
  end

  def process_users_without_account
     s = TempUserNote.where(encrypted_email: nil)
     s
  end

  def process_created_notes_during_time_period_date
    s = TempUserNote.where("notes_recorded_at between Date('#{@start_date}') and Date('#{@end_date}')")
    s
  end

  def process_created_notes_during_time_period
    segment_definition = "notes_recorded_at"
    if @condition == "today"
      s = TempUserNote.where("Date(#{segment_definition}) >  DATE(NOW())")
    elsif @condition == "yesterday"
      s = s.where("Date(#{segment_definition} >  DATE_SUB(CURDATE(), INTERVAL 1 day)")
    elsif @hour_day_week == "hour"
      s = TempUserNote.where("#{segment_definition} > DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      s = TempUserNote.where("DATE(#{segment_definition}) > DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_recorded_daily_activity_during_time_period_date
    s = TempUserNote.joins("inner join user_activities on user_activities.user_id = temp_user_notes.user_id")
    s = s.where("user_activities.activity_date between Date('#{@start_date}') and Date('#{@end_date}')")
    s
  end

  def process_recorded_daily_activity_during_time_period
    s = TempUserNote.joins("inner join user_activities on user_activities.user_id = temp_user_notes.user_id")
    if @condition == "today"
      s = s.where("Date(user_activities.activity_date) >  DATE(NOW())")
    elsif @condition == "yesterday"
      s = s.where("Date(user_activities.activity_date) >  DATE_SUB(CURDATE(), INTERVAL 1 day)")
    elsif @hour_day_week == "hour"
      s = s.where("user_activities.activity_date > DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      s = s.where("DATE(user_activities.activity_date) > DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_specific_users
    @free_text = @free_text.strip.gsub(" ","").split(",")
    s = TempUserNote.where(user_id: @free_text)
    s
  end

  def process_notes_with_topics
    @free_text = @free_text.strip.gsub(" ","").split(",")
    clauses = (["(tags.name like ?)"] * @free_text.size).join(" or ")
    args = @free_text.map{|x| ["%#{x}%"]}
    sql_clause =  [clauses,*args.flatten]
    s = TempUserNote.joins("inner join tags").where(sql_clause).where("tags.note_id = temp_user_notes.notes_id")
    s
  end

  def process_suburb_visited
    s = TempUserNote.where("suburb is not null and suburb != ' '")
    if @condition == "today"
      s = s.where("Date(notes_recorded_at) #{@operator}  DATE(NOW())")
    elsif @hour_day_week == "hour"
      s = s.where("notes_recorded_at #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      s = s.where("DATE(notes_recorded_at) #{@operator} DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    s
  end

  def process_suburb_visited_frequency
    s = TempUserNote.find_by_sql("select roman.user_id from 
                              (SELECT user_id, COUNT(*) AS visit_count 
                              FROM temp_user_notes
                              where suburb is not null and suburb != ' '
                              GROUP BY user_id) as roman
                              where visit_count > 15;")
    s
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
    "well_being_score_list" => "Well being score List",
    "occurrences_for_each_topic_list" =>  "Occurrences for each topic list",
    "weather_condition_list" => "Weather Condition list",
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
  EMPTY = ""
  IN = "in"
  LESS_THAN = "<"
  LESS_THAN_OR_EQUAL_TO = "<="
  MORE_THAN = ">"
  MORE_THAN_OR_EQUAL_TO = ">="
  EQUAL_TO = "="
  BETWEEN_OP = "between"
  RELATION_OPERATOR = [EMPTY,LESS_THAN,LESS_THAN_OR_EQUAL_TO,MORE_THAN,MORE_THAN_OR_EQUAL_TO,EQUAL_TO]
  NON_RELATION_OPERATOR = ["yes","no"]

  TEXT_OPERATOR_LIST = {
    "equals_to" => "Equals to",
    "starts_with" => "Starts With",
    "ends_with" => "Ends With",
    "contains" => "Contains"
  }

  FAMILY = [ 
              ["Usage","usage"],
              ["Life Activity in Realifex","life_activity_in_realifex"],
              ["Time","time"],
              ["Places","places"],
              ["Category,Topics,Score","category_topic_score"],
              ["Weather","weather"],
              ["Steps","steps"],
              ["Inclusion/Exclusion","inclusion_exclusion"]
            ]
  

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
    "weather_condition_list" => ["clear",
                                  "overcast",
                                  "wind",
                                  "cloudy",
                                  "rain",
                                  "thunderstorm",
                                  "fog",
                                  "snow"
                                ],
    "future_date_list" => [ "in_1_hour",
                            "in_2_hour",
                            "in_4_hour",
                            "today",
                            "tomorrow",
                            "in_1_day",
                            "in_2_day",
                            "in_3_day",
                            "in_4_day",
                            "in_5_day",
                            "in_6_day",
                            "in_7_day",
                            "in_8_day",
                            "in_9_day"
                          ],
    "purchase_list" => [12,6,3],

    "pre_defined_time_period" => [
                              "today",
                              "yesterday",
                              "1_hour_ago",
                              "2_hour_ago",
                              "3_hour_ago",
                              "4_hour_ago",
                              "5_hour_ago",
                              "6_hour_ago",
                              "7_hour_ago", 
                              "8_hour_ago",
                              "2_day_ago",
                              "3_day_ago",
                              "4_day_ago",
                              "5_day_ago",
                              "6_day_ago",
                              "7_day_ago",
                              "14_day_ago",
                              "21_day_ago",
                              "30_day_ago",
                              "3_month_ago",
                              "6_month_ago",
                              "12_month_ago"
                            ]
      }

SEGMENT= [["Downloaded the app", "downloaded_the_app"],
          ["Last note created","last_note_created"],
          ["Users subscribed atleast once","subscribed_alteast_once"],
          ["Users with active subscription","active_subscription"],
          ["Users havent yet subscribed","havent_subscribed"],
          ["User with subscription about to expire","about_to_expire"],
          ["User with expired subscription","expired_subscription"],
          ["Categories","categories"],
          ["Feeling score","feeling_score"],
          ["Impact score","impact_score"],
          ["Average Feeling score","average_feeling_score"],
          ["Average Impact score","average_impact_score"],
          ["Well being score","well_being_score"],
          ["Average Well-being score","average_well_being_score"],
          ["Weather Condition", "weather_condition"],
          ["Notes in Realifex", "total_notes"],
          ["Last Connection", "last_connection"],
          ["Specific Users", "specific_users"],
          ["Steps", "steps"],
          ["Users with account","users_with_account"],
          ["Users w/o account","users_without_account"],
          ["Notes with topics","notes_with_topics"],
          ["Notes with Suburb visit recency","suburb_visited"],
          ["Notes with Suburb visit frequency","suburb_visited_frequency"],
          ["Created Notes during Time period (date)","created_notes_during_time_period_date"],
          ["Created Notes during Time period (period)","created_notes_during_time_period"],
          ["Recorded Daily Activity during Time period (date)","recorded_daily_activity_during_time_period_date"],
          ["Recorded Daily Activity during Time period (period)","recorded_daily_activity_during_time_period"]

        ]

  def self.drop_down_list(key)
    KEY_OPERATORS[key]
  end

  def self.collective_list(key)
    LIST_KEYS[key]
  end

  def prepare_temp_user_note_table
    ActiveRecord::Base.connection.execute("TRUNCATE temp_user_notes")
    User.populate_temp_user_notes
  end

end
