class UserActivity < ActiveRecord::Base

  belongs_to :user
  scope :active_time, -> (range) {where(activity_date: range)}

end
