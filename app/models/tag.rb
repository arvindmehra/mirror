class Tag < ActiveRecord::Base
  belongs_to :note

  scope :search, -> (term) {
    where('name LIKE ?', "%#{term}%")
  }

  def self.name_array_sorted_by_count
    self.group(:name).order('count_name DESC').count(:name).keys
  end

end
