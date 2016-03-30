class SuggestedHashtag < ActiveRecord::Base

  # Rails admin config model wise
  rails_admin do
    exclude_fields :created_at, :updated_at
    edit do
      field :language do
        help ''
      end
      field :product do
        help ''
      end
      field :hashtags do
        help 'Please Enter comma seperated words. e.g: Friends,Family,Sefie'
      end
      field :exclusion_words do
        help 'Please Enter comma seperated words. e.g: is,am,or'
      end
    end
  end

  # method with special keyword "enum" to create a dropdown list in rails admin form
  def language_enum
    keyboard_shortcodes = {
      "en-US" => "English-US",
      "en-UK" => "English-UK" ,
      "en-AU" => "English-AUS"  ,
      "fr-FR" => "French-France"  ,
      "es-ES" => "Spanish-Spain"
     }
     keyboard_shortcodes.map{|key, val| [val, key]}
  end

  def self.keyboard_suggestions
    excluded=SuggestedHashtag.where(product: "Realifex").map{|row| {row.language => row.exclusion_words}}
    suggested=SuggestedHashtag.where(product: "Realifex").map{|row| {row.language => row.hashtags}}
    excluded_words = excluded.map do |item|
      item.map{|k,v| v.split(",").map{|x| {text: x, language: k}} }
    end.flatten
    suggested_hashtags = suggested.map do |item|
      item.map{|k,v| v.split(",").map{|x| {text: x, language: k}} }
    end.flatten
    { exluded: excluded_words,suggested: suggested_hashtags}
  end


end
