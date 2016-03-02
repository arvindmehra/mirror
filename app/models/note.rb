class Note < ActiveRecord::Base
  include Filterable

  belongs_to :user

  has_many :tags, dependent: :destroy

  after_save :calculate_tags

  scope :heart_rate_range, -> (range) {where(heart_rate: range)}
  scope :sleep_time_range, -> (range) {where(sleep_time: range)}
  scope :temperature_range, -> (range) {where(temperature: range)}
  scope :steps_walked_range, -> (range) {where(steps_walked: range)}
  scope :calories_burnt_range, -> (range) {where(calories_burnt: range)}
  scope :whether_type, -> (type) {where(whether_type: type)}
  scope :score_data, -> (score) {where(:perception_score => score)}
  scope :tags, -> (tags) {where(tags: {name:tags})}
  scope :date_range, -> (range) {where(created_at: range)}
  scope :category, -> (type) {where(category: type)}

  def calculate_tags
    tags.destroy_all
    body.scan(/(?:\s|^)#(.+?)(?=[\s,.]|$)/) do |match|
      name = match.first.to_s
      index = Regexp.last_match.offset(0).first
      index = index + 1 if body[index] != "#"
      tags << Tag.new(index: index, name: name)
    end
  end

  def self.calculate_perception_score(impact_score,feeling_score)
    @feeling_score_value=0
    if(feeling_score>=5)
      @feeling_score_value=feeling_score-4
    else
      @feeling_score_value=feeling_score-5
    end
    return impact_score*@feeling_score_value
  end

end