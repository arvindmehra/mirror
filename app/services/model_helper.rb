module ModelHelper

  def expression_ids
    if expression.present?
      ids = {group: [], filter: []}
      exp = expression.gsub("AND","").split(" ")
      exp.each do |klass_id|
        if klass_id.include?("Group")
          id = klass_id.gsub('Group_', '').to_i
          ids[:group].push(id)
        else
          id = klass_id.gsub('Filter_', '').to_i
            ids[:filter].push(id)
        end
      end
      ids
    end
  end

end