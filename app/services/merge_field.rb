class MergeField

  def self.get_user_field_values(merge_field,user_ids)
    if merge_field == "notes"
      user_notes = TempUserNote.find_by_sql("SELECT  user_id, t1.total_notes, t1.total_notes/t1.date_diff as avg_notes 
                      FROM (SELECT temp_user_notes.user_id, count(*) as total_notes, min(notes_recorded_at) as min,
                      max(notes_recorded_at) as max, (datediff(max(notes_recorded_at),min(notes_recorded_at)) + 1) as date_diff
                      FROM `temp_user_notes`  WHERE `temp_user_notes`.`user_id` IN (#{user_ids.join(",")}) GROUP BY user_id) as t1")
    elsif merge_field == "average"
      user_notes = TempUserNote.find_by_sql("select user_id, avg(temperature) avg_temperature,TRUNCATE(avg(impact_score)*100/6,2) AS avg_impact,
                TRUNCATE(avg(feeling_score)*100/8,2) AS avg_feeling,
                TRUNCATE(avg(sleep_time),2) AS avg_sleep,TRUNCATE(avg(steps_walked),2) AS avg_steps
                from temp_user_notes
                where user_id  IN (#{user_ids.join(",")})
                group by user_id")

    elsif merge_field == "latest_note"
        user_notes = TempUserNote.find_by_sql("SELECT t2.user_id,t2.notes_recorded_at, t2.steps_walked, t2.temperature,t2.sleep_time,
                  TRUNCATE(t2.feeling_score * 100/8,2) feeling_score,TRUNCATE(t2.impact_score*100/6,2) impact_score,
                  TRUNCATE((t2.impact_score * t2.feeling_score) * 100/48,2) wbs,suburb,category
                FROM temp_user_notes t2
                  INNER JOIN
                      (SELECT user_id, MAX(notes_recorded_at) max_date
                    FROM temp_user_notes
                      GROUP BY user_id
                      ) t1 ON t2.user_id = t1.user_id AND
                          t2.notes_recorded_at = t1.max_date
                          where t1.user_id IN (#{user_ids.join(",")})")
    elsif merge_field == "topics"
      user_notes = TempUserNote.find_by_sql("select n.user_id,group_concat(t.name) topics,count(t.name) times
                  from  notes n inner join tags t on n.id=t.note_id
                  inner join ( select user_id ,max(id) last_note_id from notes group by user_id) x on x.user_id=n.user_id and n.id=x.last_note_id
                  where n.user_id IN (#{user_ids.join(",")})
                  group by n.user_id")
    elsif merge_field == "most_used"
      user_notes = TempUserNote.find_by_sql("SELECT distinct user_id,
                            (SELECT category FROM temp_user_notes t1
                             WHERE t1.user_id = T.user_id
                             GROUP BY category ORDER BY count(*) DESC LIMIT 1) as category,
                            (SELECT suburb FROM temp_user_notes t2
                             WHERE t2.user_id = T.user_id
                             GROUP BY suburb ORDER BY count(*) DESC LIMIT 1) as suburb,
                            (SELECT date(notes_recorded_at) FROM temp_user_notes t3
                             WHERE t3.user_id = T.user_id
                             GROUP BY date(notes_recorded_at) ORDER BY count(*) DESC LIMIT 1) as notes_recorded_at,
                            (SELECT whether_type FROM temp_user_notes t4
                             WHERE t4.user_id = T.user_id
                             GROUP BY whether_type ORDER BY count(*) DESC LIMIT 1) as whether_type
                      FROM (SELECT DISTINCT user_id FROM temp_user_notes
                        where  user_id in (#{user_ids.join(",")})) T")
    elsif merge_field == "goal"
      user_notes = TempUserNote.where(user_id: user_ids).select(:user_id,:activity_goal).group(:user_id,:activity_goal)
    end
    user_notes
  end

end