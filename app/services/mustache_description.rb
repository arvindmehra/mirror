class MustacheDescription

  def self.render(template,user_record)
    merge_field = template.merge_field
    if merge_field == "notes"
      Mustache.render(template.description,{total_notes: user_record.total_notes, avg_notes: user_record.avg_notes})
    elsif merge_field == "temperature" || merge_field == "steps" || merge_field == "sleep" || merge_field == "feeling" || merge_field == "impact" || merge_field == "wbs"
      Mustache.render(template.description,{steps_latest_note: user_record.steps_walked,temperature_latest_note: user_record.temperature,sleep_time_latest_note: user_record.sleep_time,
                                            feeling_score_latest_note: user_record.feeling_score,impact_score_latest_note: user_record.impact_score,wbs_latest_note: user_record.wbs,
                                            avg_steps: user_record.avg_steps,avg_temperature: user_record.avg_temp, avg_sleep_time: user_record.avg_sleep_time,avg_feeling_score: user_record.avg_feeling_score,
                                            avg_impact_score: user_record.avg_impact_score,avg_wbs: user_record.avg_wbs}
                      )
    elsif merge_field == "suburb"
      Mustache.render(template.description,{suburb_latest_note: user_record.suburb})
    elsif merge_field == "category"
      Mustache.render(template.description,{category_latest_note: user_record.category})
    elsif merge_field == "weather"
      Mustache.render(template.description,{weather_latest_note: user_record.whether_type})
    elsif merge_field == "regional_date"
      Mustache.render(template.description,{date_latest_note: user_record.notes_recorded_at})
    elsif merge_field == "goal"
      Mustache.render(template.description,{goal_latest_note: user_record.activity_goal})
    end
  end

end