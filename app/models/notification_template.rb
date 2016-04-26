class NotificationTemplate < ActiveRecord::Base

	belongs_to :rule_engine

	 CTA = [["Reflect", "reflect"],
          ["Create a note","create_a_note"],
          ["Convert to a note","convert_to_a_note"],
          ["Provide feedback","provide_feedback"],
          ["Set a new goal","set_a_new_goal"],
          ["Subscribe","subscribed"],
          ["Chat with Alex","chat_with_alexs"],
          ["Upgrade to new version","upgrate_to_a_new_version"]
        ]


 


end
