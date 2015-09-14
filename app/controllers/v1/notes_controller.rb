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
      #expire_user_caches()
      render :show
    else
      render json: {errors: @note.errors.full_messages}
    end
  end

  private


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
    params.require(:note).permit(:body, :category, :impact, :feeling, :impact_score, :feeling_score, :latitude, :longitude, :city, :suburb, :country, :address, :recorded_at)
  end

end
