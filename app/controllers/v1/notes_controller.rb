class V1::NotesController < V1::BaseController

  before_action :set_note, only: [:show, :update, :destroy]

  def search
    @notes = @current_user.notes.includes(:tags).where("body LIKE ?", "%#{params[:text]}%").reverse_order.page(params[:page] || 1)
  end

  # GET /notes
  def index
    #@notes = Rails.cache.fetch("notes/index/#{@current_user.id}") { @current_user.notes.includes(:tags).reverse_order }
    @notes = @current_user.notes.includes(:tags).reverse_order
  end
  
  # GET /notes/:id
  def show
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user = @current_user

    if @note.save
      # Lets save images also
      @base_path="note_images/"+(@note.id/1000).to_s+"/"+@note.id.to_s
      if params[:original_image] then
        @file_name_with_path=@base_path+"/original_"+params[:original_image].original_filename
        p @file_name_with_path
        save_screenshot_to_s3(params[:original_image].path,@file_name_with_path)
        @note.original_image_path= @file_name_with_path
      end

      if params[:thumb_image] then
        p @base_path
        @file_name_with_path=@base_path+"/thumb_"+params[:thumb_image].original_filename
        save_screenshot_to_s3(params[:thumb_image].path,@file_name_with_path)
        @note.thumb_image_path= @file_name_with_path
      end

      if params[:original_image] or params[:thumb_image]
        @note.save
      end
      #expire_user_caches()
      render :show
    else
      render json: { errors: @note.errors.full_messages }
    end
  end

  def destroy
    @note.destroy
    head :no_content
  end

  # PATCH /notes/:id
  def update
    if @note.update(note_params)

      # Lets save images also
      @base_path="note_images/"+(@note.id/1000).to_s+"/"+@note.id.to_s

      if (params[:original_image] or params[:delete_original_image])
        begin
          delete_from_s3(@note.original_image_path)
          @note.original_image_path= ''
        rescue Exception => e
        end
      end

      if params[:thumb_image] or params[:delete_thumb_image]
        begin
          delete_from_s3(@note.thumb_image_path)
          @note.thumb_image_path= ''
        rescue Exception => e
        end
      end

      if params[:original_image] then
        @file_name_with_path=@base_path+"/original_"+Time.now.to_i.to_s+"_"+params[:original_image].original_filename
        save_screenshot_to_s3(params[:original_image].path,@file_name_with_path)
        @note.original_image_path= @file_name_with_path
      end

      if params[:thumb_image] then
        @file_name_with_path=@base_path+"/thumb_"+Time.now.to_i.to_s+"_"+params[:thumb_image].original_filename
        save_screenshot_to_s3(params[:thumb_image].path,@file_name_with_path)
        @note.thumb_image_path= @file_name_with_path
      end

      @note.save

      #expire_user_caches()
      render :show
    else
      render json: {errors: @note.errors.full_messages}
    end
  end

  private

  def save_screenshot_to_s3(image_location, file_name_with_path)
    service = AWS::S3.new(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)
    s3_file = service.buckets[AWS_BUCKET_NAME].objects[file_name_with_path].write(:file => image_location)
    s3_file.acl = :public_read
  end

  def delete_from_s3(file_name_with_path)
    service = AWS::S3.new(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)
    service.buckets[AWS_BUCKET_NAME].objects[file_name_with_path].delete()
    # service.delete(key: file_name_with_path, bucket: AWS_BUCKET_NAME)
  end

  def expire_user_caches()
    Rails.cache.delete("tags/index/#{@current_user.id}")
    Rails.cache.delete("notes/index/#{@current_user.id}")
  end
  
  def set_note
    @note = Note.find(params[:id])
    if @note.user != @current_user
      head :unauthorized
    end
  end

  def note_params
    # VIKASH Commenting this
    # params.require(:note).permit(:body, :category, :impact, :feeling, :impact_score, :feeling_score, :latitude, :longitude, :city, :suburb, :country, :address, :recorded_at)
    params.permit(:body, :category, :impact, :feeling, :impact_score, :feeling_score, :latitude, :longitude, :city, :suburb, :country, :address, :recorded_at, :heart_rate, :sleep_time, :temperature, :whether_type, :steps_walked, :calories_burnt)
  end

end
