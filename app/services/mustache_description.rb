class MustacheDescription

  def self.render(template,user_record)
    merge_field = template.merge_field
    if merge_field == "notes"
      Mustache.render(template.description,{total_notes: user_record.total_notes, avg_notes: user_record.avg_notes})
    elsif merge_field == "average"
      Mustache.render(template.description,{avg_steps: user_record.avg_steps,avg_temperature: user_record.avg_temperature,
                                            avg_sleep_time: user_record.avg_sleep,avg_feeling_score: user_record.avg_feeling,
                                            avg_impact_score: user_record.avg_impact}
                      )
    elsif merge_field == "latest_note"
      Mustache.render(template.description,{steps_latest_note: user_record.steps_walked,temperature_latest_note: user_record.temperature,
                                            sleep_time_latest_note: user_record.sleep_time,
                                            feeling_score_latest_note: user_record.feeling_score,impact_score_latest_note: user_record.impact_score})
    elsif merge_field == "topics"
      Mustache.render(template.description,{topics_latest_note: user_record.topics})
    elsif merge_field == "most_used"
      Mustache.render(template.description,{most_used_category: user_record.category, most_used_suburb: user_record.suburb,
                                            most_used_date: user_record.notes_recorded_at,most_used_weather: user_record.whether_type})
    elsif merge_field == "goal"
      Mustache.render(template.description,{goal_latest_note: user_record.activity_goal})
    end
  end

end