class UserNotification < ActiveRecord::Base

  belongs_to :user
  scope :read, -> { where(read_status: 1) }
  scope :unread, -> { where("read_status is ? or read_status = ?",nil,0) }
  scope :non_deleted, -> { where("mark_deleted is ? or mark_deleted = ?",nil,0) }

end
