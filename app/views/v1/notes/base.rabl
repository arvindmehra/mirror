object @note

attributes :id, :body, :impact, :feeling, :impact_score, :feeling_score, :category, :city, :suburb, :country, :latitude, :longitude, :created_at, :recorded_at, :original_image_path, :thumb_image_path, :heart_rate, :sleep_time, :temperature, :whether_type, :steps_walked, :calories_burnt, :note_coordinate

child :tags do
  attributes :name, :index
end