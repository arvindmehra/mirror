class Note < ActiveRecord::Base
  belongs_to :user

  has_many :tags, dependent: :destroy

  after_save :calculate_tags

  def calculate_tags
    tags.destroy_all
    body.scan(/(?:\s|^)#(.+?)(?=[\s,.]|$)/) do |match|
      name = match.first.to_s
      index = Regexp.last_match.offset(0).first
      index = index + 1 if body[index] != "#"
      tags << Tag.new(index: index, name: name)
    end
  end

end