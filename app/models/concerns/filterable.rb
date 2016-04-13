module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtered_params)
      @notes = Note
      filter_list = date_range_scope(filtered_params).present? ? get_date_range(filtered_params) : filtered_params
      process_filters(filter_list)
    end

    def date_range_scope(filtered_params)
      filtered_params[:begin_date].present? && filtered_params[:end_date].present?
    end

    def get_date_range(filtered_params)
      if filtered_params[:today].present?
        date_range_start = filtered_params.delete(:begin_date).in_time_zone - 24.hour
        date_range_end = filtered_params.delete(:end_date).in_time_zone
        filtered_params.delete(:today)
        puts "in today"
      elsif filtered_params[:begin_date] == filtered_params[:end_date]
        if filtered_params[:begin_date].split(" ").count == 1
          puts "in with same date no timezone"
          date_range_start = (DateTime.parse(filtered_params.delete(:begin_date))-1).strftime("%Y-%m-%d")
          date_range_end = (DateTime.parse(filtered_params.delete(:end_date))+1).strftime("%Y-%m-%d")
          date_range_start = date_range_start+ " 00:00:00"
          date_range_end = date_range_end+ " 23:59:59"
        elsif filtered_params[:begin_date].split(" ").count == 3
          puts "in with same date with timezone"
          date_range_start = filtered_params.delete(:begin_date).in_time_zone
          date_range_end = filtered_params.delete(:end_date).in_time_zone
        end
      else
        puts "in custom filter"
        date_range_start = filtered_params.delete(:begin_date).in_time_zone
        date_range_end = filtered_params.delete(:end_date).in_time_zone
      end
      date_range = date_range_start .. date_range_end
      filtered_params[:date_range] = date_range
      filtered_params
    end

    def process_filters(filter_list)
      range_filters = [:heart_rate_range,:sleep_time_range,:temperature_range,:steps_walked_range,:calories_burnt_range]
      filter_list.each do |key, value|
        if range_filters.include?(key.to_sym)  # => "125-130,131-135" for heart_rate_range,sleep_time_range,temperature_range,steps_walked_range,calories_burnt_range
          value = value.gsub("-","..") # => "125..130,131..135"
          value = value.split(",") # => ["125..130", "131..135"]
          value = value.map{|x| Range.new(*x.split("..").map(&:to_i))} # => convert string into range class [125..130, 131..135]
        elsif key == "score_data" #for score_data
          value = value.split(",")
          value = value.map { |s| Note.calculate_perception_score(s.split("-")[0].to_i,s.split("-")[1].to_i) }
        elsif key == "date_range" # for begin_date end_date
          value = value
        else
          value = value.split(",") #whether, category
        end
        @notes = @notes.public_send(key, value) if value.present?
      end
      @notes
    end
  end
end