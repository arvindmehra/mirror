class NotificationTemplate < ActiveRecord::Base

  has_many :user_notifications
  belongs_to :rule_engine
  scope :realtime, -> {where(execution_type: "realtime")}
  scope :for_notes, -> {where(trigger: "note_created")}
  scope :for_activity, -> {where(trigger: "activity_recorded")}
  scope :alive, -> {where(active: true)}


  include SerialPreference::HasSerialPreferences

  preferences(:filter_preferences) do
    boolean :well_being
    string :categories
    string :dashboard
    string :days_from_now
    string :topic
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
  end

  preferences(:cta_preferences) do
    string :provide_feedback_email
    string :chat_email
    string :learn_more_url
    string :take_the_survey_url
    string :anonymous_feedback_url
  end

  CATEGORY_LIST = ["","Experiences","Actions","Emotions","Decisions","Discoveries"]
  WEATHER_LIST = [  ["","Please Select"],
                    ["clear","Clear"],
                    ["overcast","Overcast"],
                    ["wind","Wind"],
                    ["cloudy","Cloudy"],
                    ["rain","Rain"],
                    ["thunderstorm","Thunderstorm"],
                    ["fog","Fog"],
                    ["snow","Snow"]
                  ]

  FUTURE_DATE_LIST = [    "",
                          "today",
                          "tomorrow",
                          "in_1_hour",
                          "in_2_hour",
                          "in_4_hour",
                          "in_1_day",
                          "in_2_day",
                          "in_3_day",
                          "in_4_day",
                          "in_5_day",
                          "in_6_day",
                          "in_7_day",
                          "in_8_day",
                          "in_9_day"
                      ]

  DASHBOARD = ["","Life Path","Life Map","Life Focus","Life Summary","Life Activity"]

  TRIGGERS = [["",""],["When notes is created","note_created"],["When activity is recorded","activity_recorded"]]

  ELAPSED_TIME = [1,2,3,4,5]

  DISPLAY_SCREEN = [["",""],["Option", "option"],["Suggestion","suggestion"]]

  CTA = {
        "reflect"=>"Reflect",
        "create_a_note"=>"Create a note",
        "convert_to_a_note"=>"Convert to a note",
        "provide_feedback"=>"Provide feedback",
        "set_a_new_goal"=>"Set a new goal",
        "subscribed"=>"Subscribe",
        "chat_with_alexs"=>"Chat with Alex",
        "upgrate_to_a_new_version"=>"Upgrade to new version",
        "autofocus"=> "AutoFocus"
      }

  CATEGORY = [["Activity","activity"],
              ["Behaviour","behaviour"],
              ["User","user"],
              ["LifeAutoFocus","lifeautofocus"]]

  def get_scope_users
    users = rule_engine.get_scope_users
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

end
