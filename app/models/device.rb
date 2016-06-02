class Device < ActiveRecord::Base
  
  belongs_to :user
  scope :with_notification_token, -> {where.not("notification_token"=>nil)}
  

end
