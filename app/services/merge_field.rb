class MergeField

  def self.get_user_field_values(merge_field,user_ids)
    if merge_field == "notes"
      user_notes = TempUserNote.select("user_id, t1.total_notes, t1.total_notes/t1.date_diff as avg_notes")
                  .from(TempUserNote.where(user_id: user_ids)
                  .select("temp_user_notes.user_id, count(*) as total_notes, min(notes_recorded_at) as min,
                  max(notes_recorded_at) as max, (datediff(max(notes_recorded_at),min(notes_recorded_at)) + 1) as date_diff")
                  .group(:user_id),"as t1")

              # user_id,total_notes,avg_notes

              # SELECT user_id, t1.total_notes, t1.total_notes/t1.date_diff as avg_notes FROM (SELECT temp_user_notes.user_id,
              # count(*) as total_notes, min(notes_recorded_at) as min,
              # max(notes_recorded_at) as max, (datediff(max(notes_recorded_at),min(notes_recorded_at)) + 1) as date_diff 
              # FROM `temp_user_notes`  WHERE `temp_user_notes`.`user_id` IN (135, 136) GROUP BY user_id) as t1 user_notes
    elsif merge_field == "regional_date"
      user_notes = TempUserNote.where(user_id: user_ids).select("user_id,Max(notes_recorded_at) as latest_note_date").group(:user_id)

                    # SELECT user_id,Max(notes_recorded_at) as latest_date FROM `temp_user_notes`  
                    # WHERE `temp_user_notes`.`user_id` IN (23, 29, 41, 135, 134, 133) 
                    # GROUP BY user_id

    elsif merge_field == "suburb"
      # user_notes = TempUserNote.where(user_id: user_ids).where.not(suburb: nil).select("user_id,Max(notes_recorded_at) as latest_note_suburb")
      #               .group(:user_id)

        user_notes = TempUserNote.find_by_sql("SELECT user_id,suburb, notes_recorded_at
                FROM temp_user_notes WHERE notes_recorded_at IN (
                  SELECT MAX( notes_recorded_at )
                    FROM temp_user_notes WHERE user_id in (#{user_ids.join}) GROUP BY user_id
                )
                ORDER BY user_id ASC, notes_recorded_at DESC")

                    # SELECT user_id,Max(notes_recorded_at) as latest_note_suburb FROM `temp_user_notes`  
                    # WHERE `temp_user_notes`.`user_id` IN (23, 29, 41, 135, 134, 133) 
                    # AND (`temp_user_notes`.`suburb` IS NOT NULL) GROUP BY user_id
    elsif merge_field == "category"
      user_notes = TempUserNote.find_by_sql("SELECT user_id,category, notes_recorded_at
                FROM temp_user_notes WHERE notes_recorded_at IN (
                  SELECT MAX( notes_recorded_at )
                    FROM temp_user_notes WHERE user_id in (#{user_ids.join}) GROUP BY user_id
                )
                ORDER BY user_id ASC , notes_recorded_at DESC")

    elsif merge_field == "temperature" || merge_field == "steps" || merge_field == "sleep" || merge_field == "feeling" || merge_field == "impact" || merge_field == "wbs"
      user_notes = TempUserNote.find_by_sql("SELECT t2.user_id,t2.notes_recorded_at, t2.steps_walked, t2.temperature,t2.sleep_time,
                  TRUNCATE(t2.feeling_score * 100/8,2) feeling_score,TRUNCATE(t2.impact_score*100/6,2) impact_score,
                  TRUNCATE((t2.impact_score * t2.feeling_score) * 100/48,2) wbs, avg_steps,avg_temp,avg_sleep_time,
                  avg_feeling_score,avg_impact_score,avg_wbs
                FROM temp_user_notes t2
                  INNER JOIN
                      (SELECT user_id, MAX(notes_recorded_at) max_date, TRUNCATE(avg(steps_walked),2) avg_steps,
                      TRUNCATE(avg(temperature),2) avg_temp, TRUNCATE(avg(sleep_time),2) avg_sleep_time,
                      TRUNCATE((avg(feeling_score) * 100/6),2) avg_feeling_score,TRUNCATE((avg(impact_score) * 100/6),2) avg_impact_score,
                      TRUNCATE((avg(perception_score) * 100/24),2) avg_wbs
                    FROM temp_user_notes
                      GROUP BY user_id
                      ) t1 ON t2.user_id = t1.user_id AND
                          t2.notes_recorded_at = t1.max_date
                          where t1.user_id in (#{user_ids.join})")
    elsif merge_field == "weather"
      user_notes = TempUserNote.find_by_sql("SELECT t2.user_id,notes_recorded_at, whether_type
                      FROM temp_user_notes t2
                              INNER JOIN
                              ( SELECT user_ID, MAX(notes_recorded_at) max_date
                                  FROM temp_user_notes
                                  GROUP BY user_ID
                              ) t1 ON t2.user_ID = t1.user_ID AND
                              t2.notes_recorded_at = t1.max_date
                              WHERE t1.user_id in (#{user_ids.join})")
      elsif merge_field == "date"
      user_notes = TempUserNote.find_by_sql("SELECT t2.user_id,date(notes_recorded_at)
                      FROM temp_user_notes t2
                              INNER JOIN
                              ( SELECT user_ID, MAX(notes_recorded_at) max_date
                                  FROM temp_user_notes
                                  GROUP BY user_ID
                              ) t1 ON t2.user_ID = t1.user_ID AND
                              t2.notes_recorded_at = t1.max_date
                              WHERE t1.user_id in (#{user_ids.join})")
    elsif merge_field == "goal"
      user_notes = TempUserNote.where(user_id: user_ids).select(:user_id,:activity_goal).group(:user_id,:activity_goal)
    end
    user_notes
  end

end