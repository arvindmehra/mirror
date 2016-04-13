class UserNotification < ActiveRecord::Base

  belongs_to :user
  scope :unread, -> {where(read_status: 0)}

end
