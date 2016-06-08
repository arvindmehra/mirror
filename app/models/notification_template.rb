class NotificationTemplate < ActiveRecord::Base

  has_many :user_notifications
  belongs_to :rule_engine
  
  scope :realtime, -> {where(execution_type: "realtime")}
  scope :for_notes, -> {where(trigger: "note_created")}
  scope :for_activity, -> {where(trigger: "activity_recorded")}
  scope :alive, -> {where(active: true)}
  scope :batch, ->{where(execution_type: "batch")}

  include SerialPreference::HasSerialPreferences

  preferences(:filter_preferences) do
    boolean :well_being
    string :autofocus_categories
    string :dashboard
    string :days_from_now
    string :topics
    string :score_data
    string :heart_rate_min
    string :heart_rate_max
    string :heart_rate_medium
    string :steps_walked_min
    string :steps_walked_medium
    string :steps_walked_max
    string :sleep_time_min
    string :sleep_time_medium
    string :sleep_time_max
    string :weather
    string :temperature_min
    string :temperature_medium
    string :temperature_max
    string :calories_min
    string :calories_medium
    string :calories_max
    string :provide_feedback_email
    string :chat_email
    string :learn_more_url
    string :take_the_survey_url
    string :anonymous_feedback_url

    string :secondary_provide_feedback_email
    string :secondary_chat_email
    string :secondary_learn_more_url
    string :secondary_take_the_survey_url
    string :secondary_anonymous_feedback_url
  end

  MERGE_FIELDS = [  ["",""],
                    ["Notes","notes"],
                    ["Average","average"],
                    ["Latest Note","latest_note"],
                    ["Topics","topics"],
                    ["Most Used","most_used"]
                  ]

  CATEGORY_LIST = ["Experiences","Actions","Emotions","Decisions","Discoveries"]
  WEATHER_LIST = [
                    ["clear","Clear"],
                    ["overcast","Overcast"],
                    ["wind","Wind"],
                    ["cloudy","Cloudy"],
                    ["rain","Rain"],
                    ["thunderstorm","Thunderstorm"],
                    ["fog","Fog"],
                    ["snow","Snow"]
                  ]

FUTURE_DATE_LIST = [  "",
                      "Today",
                      "Yesterday",
                      "Last 2 Days",
                      "Last 3 Days",
                      "Last 4 Days",
                      "Last 5 Days",
                      "Last 6 Days",
                      "Last 7 Days",
                      "Last 14 Days",
                      "Last 21 Days",
                      "Last 30 Days",
                      "Last 3 Months",
                      "Last 6 Months",
                      "Last 12 Months"
                    ]

RECURRENCE_TIME_PERIOD_LIST = [
                                "",
                                "Every Day",
                                "Every second day",
                                "Every third day",
                                "Every fourth day",
                                "Every fifth day",
                                "Every sixth day",
                                "Every week",
                                "Every 2 weeks",
                                "Every 3 weeks",
                                "Every month",
                                "Every 2 months",
                                "Every 3 months"
                            ]

  DASHBOARD = [["",""],["Life Path","life_path"],["Life Map","life_map"],["Life Focus","life_focus"],["Life Summary","life_summary"],["Life Activity","life_activity"]]

  TRIGGERS = [["",""],["When notes is created","note_created"],["When activity is recorded","activity_recorded"]]

  ELAPSED_TIME = [1,2,3,4,5]

  DISPLAY_SCREEN = [["Option", "option"],["Suggestion","suggestion"]]

  CTA = {
        "create_a_note"=>"Create a note",
        "provide_feedback"=>"Provide feedback",
        "set_a_new_goal"=>"Set a new goal",
        "activate"=>"Activate",
        "chat"=>"Chat",
        "upgrate_to_a_new_version"=>"Upgrade to new version",
        "autofocus"=> "AutoFocus",
        "learn_more"=> "Learn More",
        "take_survey"=> "Take the survey",
        "anonymous_feedback" => "Anonymous Feedback",
        "create_account" => "Create Account"
      }

  CATEGORY = [["Activity","activity"],
              ["Behaviour","behaviour"],
              ["User","user"],
              ["LifeAutoFocus","lifeautofocus"]]

  ELAPSE_TIME = [
                  ["0 min","0"],
                  ["1 min","60"],
                  ["2 min","120"],
                  ["3 min","180"],
                  ["4 min","240"],
                  ["5 min","300"],
                  ["6 min","360"],
                  ["7 min","420"],
                  ["8 min","480"],
                  ["9 min","560"],
                  ["10 min","600"],
                  ["11 min","660"],
                  ["12 min","720"],
                  ["13 min","780"],
                  ["14 min","840"],
                  ["15 min","900"],
                  ["16 min","960"],
                  ["17 min","1020"],
                  ["18 min","1080"],
                  ["19 min","1140"],
                  ["20 min","1200"],
                  ["30 min","1260"],
                  ["40 min","1320"],
                  ["50 min","1380"],
                  ["60 min","1440"],
                  ["90 min","1500"],
                  ["120 min","1560"],
                  ["180 mins","1620"]
                ]

  IN_EX_LIST = [
                ["Include users who have already been targeted by this notification (frequency)","include_already_targeted"],
                ["Exclude users who have already been targeted by this notification (frequency)","exclude_already_targeted"],
                ["Include users who have found this notification useful","include_found_useful"],
                ["Exclude users who have found this notification useful","exclude_found_useful"],
                ["Include users who have been targeted by another notification","include_targeted_by_another_notification"],
                ["Exclude users who have been targeted by another notification","exclude_targeted_by_another_notification"],
                ["Include users who have already been targeted by this notification (elapsed time)","include_already_targeted_elapsed_time"],
                ["Exclude users who have already been targeted by this notification (elapsed time)","exclude_already_targeted_elapsed_time"]

              ]

  KEY_OPERATORS = {
      "already_targeted_list" => ["",
                                  "1_time",
                                  "2_times",
                                  "3_times",
                                  "4_times",
                                  "5_times",
                                  "6_times",
                                  "7_times",
                                  "8_times",
                                  "9_times",
                                  "10_times",
                                  "11_times",
                                  "12_times",
                                  "13_times",
                                  "14_times",
                                  "15_times",
                                  "30_times",
                                  "50_times"
                                ],

      "useful_list" => [true,false,"NC"],
      "recency_list" => [ "today",
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
                        ]
      }

  def get_scope_users
    begin
      users_fulfilling_filters = rule_engine.get_scope_users
    rescue Exception => e
      Rails.logger.info "[ERROR] in loading users #{e} Possibly no rule found"
    end
    if in_exclusion_segment.present?
      users_fulfilling_filters = check_inclusion_exclusion_list_for(users_fulfilling_filters)
    end
    users_fulfilling_filters
  end

  def fire
    Pusher.perform_async(self.id)
  end

  def deactivate
    self.active = false
    self.save
  end

  def activate
    self.active = true
    self.save
  end

  def check_inclusion_exclusion_list_for(users_fulfilling_filters)
    if (in_exclusion_segment == "include_already_targeted") || (in_exclusion_segment == "exclude_already_targeted")
      @already_targeted_time = in_exclusion_condition.split("_").first
    elsif in_exclusion_segment == "include_already_targeted_elapsed_time" || (in_exclusion_segment == "exclude_already_targeted_elapsed_time") 
      @digit, @hour_day_week = in_exclusion_condition.split("_")
    elsif (in_exclusion_segment == "include_found_useful") || (in_exclusion_segment == "exclude_found_useful")
      @condition = in_exclusion_condition
    end
    @operator = in_exclusion_operator
    nt_id = in_exclusion_notification_id == 0 ? self.id : in_exclusion_notification_id
    @notification_template = NotificationTemplate.find_by(id: nt_id)
    send("process_#{in_exclusion_segment}",users_fulfilling_filters)
  end

  def process_include_already_targeted(users_fulfilling_filters)
    target_users = []
    operator = in_exclusion_operator
    users_already_targeted = @notification_template.user_notifications.pluck(:user_id)
    user_occurences = users_already_targeted.inject(Hash.new(0)) { |user_hash, e| user_hash[e] += 1; user_hash}
    puts users_fulfilling_filters
    puts user_occurences
    users_fulfilling_filters.map do |user|
      if user_occurences[user].send(@operator,@already_targeted_time.to_i)
        target_users << user
      end
    end
    target_users.uniq
  end

  def process_exclude_already_targeted(users_fulfilling_filters)
    target_users = []
    operator = in_exclusion_operator
    condition = in_exclusion_condition
    users_already_targeted = @notification_template.user_notifications.pluck(:user_id)
    user_occurences = users_already_targeted.inject(Hash.new(0)) { |user_hash, e| user_hash[e] += 1; user_hash}
    puts users_fulfilling_filters
    puts user_occurences
    users_fulfilling_filters.map do |user|
      if user_occurences[user].send(@operator,@already_targeted_time.to_i)
        target_users << user
      end
    end
    (users_fulfilling_filters - target_users).uniq
  end

  def process_include_found_useful(users_fulfilling_filters)
    users_already_targeted = users_in_criteria(users_fulfilling_filters)
    users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id).uniq
  end

  def process_exclude_found_useful(users_fulfilling_filters)
    users_already_targeted = users_in_criteria(users_fulfilling_filters)
    (users_fulfilling_filters - users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id)).uniq
  end

  def users_in_criteria(users_fulfilling_filters)
    if in_exclusion_condition == "true"
      users_already_targeted = @notification_template.user_notifications.useful
    elsif in_exclusion_condition == "false"
      users_already_targeted = @notification_template.user_notifications.not_useful
    elsif in_exclusion_condition == "NC"
      users_already_targeted = @notification_template.user_notifications.not_commented_on_useful
    else
      return users_fulfilling_filters
    end
  end

  def process_include_targeted_by_another_notification(users_fulfilling_filters)
    users_already_targeted = @notification_template.user_notifications
    users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id)
  end

  def process_exclude_targeted_by_another_notification(users_fulfilling_filters)
    users_already_targeted = @notification_template.user_notifications
    users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id)
    (users_fulfilling_filters - users_already_targeted).uniq
  end

  def process_include_already_targeted_elapsed_time(users_fulfilling_filters)
    segment_definition = "sent_at"
    if @condition == "today"
      users_already_targeted = @notification_template.user_notifications.where("Date(#{segment_definition}) #{@operator}  DATE(NOW())")
    elsif @hour_day_week == "hour"
      users_already_targeted = @notification_template.user_notifications.where("#{segment_definition} #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      users_already_targeted = @notification_template.user_notifications.where("DATE(#{segment_definition}) #{@operator} DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id).uniq
  end

  def process_exclude_already_targeted_elapsed_time(users_fulfilling_filters)
    segment_definition = "sent_at"
    if @condition == "today"
      users_already_targeted = @notification_template.user_notifications.where("Date(#{segment_definition}) #{@operator}  DATE(NOW())")
    elsif @hour_day_week == "hour"
      users_already_targeted = @notification_template.user_notifications.where("#{segment_definition} #{@operator} DATE_SUB(NOW(), INTERVAL #{@digit} #{@hour_day_week})")
    else
      users_already_targeted = @notification_template.user_notifications.where("DATE(#{segment_definition}) #{@operator} DATE_SUB(CURDATE(), INTERVAL #{@digit} #{@hour_day_week})")
    end
    (users_fulfilling_filters -  users_already_targeted.where(user_id: users_fulfilling_filters).pluck(:user_id)).uniq
  end

  def self.drop_down_list(key)
    KEY_OPERATORS[key]
  end

end
