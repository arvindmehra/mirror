class RuleEngine < ActiveRecord::Base
  attr_accessor :filter_one
  has_many :notification_templates

  def get_scope_users
    prepare_temp_user_note_table
    unwind_expression
  end

  def unwind_expression
    exp = expression.gsub("AND","").split(" ")
    exp_size = exp.size
    exp.each_with_index do |klass_id,index|
      if klass_id.include?("Group")
        id = klass_id.gsub('Group_', '')
        @users = FilterGroup.find_by(id: id).get_scope_users(true,false)
      else
        id = klass_id.gsub('Filter_', '')
        @users = Filter.find_by(id: id).get_scope_users(true,false)
      end
      if (index != (exp_size - 1) && !@users.blank?)
        if !@users.is_a?(Hash)
          if @users.blank?
            ActiveRecord::Base.connection.execute("truncate temp_user_notes")
            return []
          else
            ActiveRecord::Base.connection.execute("delete from temp_user_notes where user_id NOT IN (#{@users.join(",")})")
          end
        else
          if @users[:temp_user_notes_ids].blank?
            ActiveRecord::Base.connection.execute("truncate temp_user_notes")
            return []
          else
            @users = @users[:temp_user_notes_ids].flatten
            ActiveRecord::Base.connection.execute("delete from temp_user_notes where id NOT IN (#{@users.join(",")})")
          end
        end
      end
    end
    @users
  end

  def prepare_temp_user_note_table
    ActiveRecord::Base.connection.execute("TRUNCATE temp_user_notes")
    User.populate_temp_user_notes
  end

end
