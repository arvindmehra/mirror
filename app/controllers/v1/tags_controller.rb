class V1::TagsController < V1::BaseController

  def search
    render json: { tags: @current_user.tags.search(params[:text]).name_array_sorted_by_count }
  end

  def index

    #@user_tag_statistics = Rails.cache.fetch("tags/index/#{@current_user.id}"){ UserTagStatisticsReport.new(@current_user) }
    @user_tag_statistics = UserTagStatisticsReport.new(@current_user)
    render json: @user_tag_statistics.tag_statistics
  end

end
