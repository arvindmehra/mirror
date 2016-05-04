class NotificationTemplate < ActiveRecord::Base

  has_many :user_notifications
	belongs_to :rule_engine

  CONDITION = [["When daily goal is reached","goal_reached"]]

  ELAPSED_TIME = [1,2,3,4,5]

	 DISPLAY_SCREEN = [["Option", "option"],
                    ["Suggestion","suggestion"]]


    CTA = {"reflect"=>"Reflect", 
          "create_a_note"=>"Create a note", 
          "convert_to_a_note"=>"Convert to a note", 
          "provide_feedback"=>"Provide feedback", 
          "set_a_new_goal"=>"Set a new goal", 
          "subscribed"=>"Subscribe", 
          "chat_with_alexs"=>"Chat with Alex", 
          "upgrate_to_a_new_version"=>"Upgrade to new version"}

  CATEGORY = [["Activity","activity"],
              ["Behaviour","behaviour"],
              ["User","user"]]

  def get_scope_users
    users = rule_engine.get_scope_users
  end

  def trigger
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
