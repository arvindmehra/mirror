class UserTagStatisticsReport

  attr_accessor :tag_statistics

  def initialize(user)
    @tag_statistics = []
    build_tag_statistics(user)
  end

  private
    def build_tag_statistics(user)
      
      tags = user.tags.group(:name)
      
      tags.each do |tag|
        
        tag_statistics_report = TagStatisticsReport.new
        tag_statistics_report.tag = tag.name
        tags_with_same_name = user.tags.where("name = ?", tag.name)
        tag_statistics_report.usage_count = tags_with_same_name.count
        
        tag_statistics_report.low_impact_max, 
        tag_statistics_report.high_impact_max,
        tag_statistics_report.low, 
        tag_statistics_report.high,
        tag_statistics_report.category =
        calculate_feeling_counts(tags_with_same_name)

        @tag_statistics << tag_statistics_report
      end
    end

    def calculate_feeling_counts(tags_with_same_name)
      
      category_counts = Hash.new { |hash, key| hash[key] = 0 }
      low_impact_counts = [0,0,0,0,0,0,0,0]
      high_impact_counts = [0,0,0,0,0,0,0,0]
      low_mode_count = 0
      high_mode_count = 0

      tags_with_same_name.each do |tag|
        feeling_score = tag.note.feeling_score
        impact = tag.note.impact

        if impact == :High.to_s
          high_impact_counts[feeling_score.to_i - 1] += 1
          high_mode_count = get_current_max(high_impact_counts[feeling_score.to_i - 1], high_mode_count)
        else
          low_impact_counts[feeling_score.to_i - 1] += 1
          low_mode_count = get_current_max(low_impact_counts[feeling_score.to_i - 1], low_mode_count)
        end

        category_counts[tag.note.category.to_s] += 1
      end

      return low_mode_count, high_mode_count, low_impact_counts, high_impact_counts, category_counts.max_by { |key, value| value }[0]
    end

    def get_current_max(count, max)
      count > max ? count : max
    end
end