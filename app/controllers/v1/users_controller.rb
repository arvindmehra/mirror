class V1::UsersController < V1::BaseController
  
  skip_before_action :require_user, except: [:show, :update]

  def sign_in
    if @user = User.find_by_email(params[:email])
      if @user.authenticate(params[:password])
        @current_device.update(user: @user)
        @user.increment!(:login_count)
        render :show
      else
        render json: {errors: ["Incorrect user/password combination."]}, status: :unauthorized
      end
    else
      render json: {errors: ["User not found."]}, status: 404
    end
  end

  def create_password_reset # from API : POST /password_resets {"email": "value"}
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      head :no_content
    else
      render json: {errors: ["User not found"]}, status: 404
    end
  end

  def create
    @user = User.new(email: params[:email], password: params[:password])
    
    @user.login_count = 0
    @user.app_opens_count = 1
    @user.auth_token_created_at = Time.now

    if @user.save
      render :show
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def sign_out
    @current_device.update(user: nil,notification_token: nil)
    head :no_content
  end

  def show
    @user = @current_user
  end

  def update
    if params[:email] && params[:password]
      if @current_user.update(email: params[:email], password: params[:password])
        @user = @current_user
        render :show
      else
        render json: {errors: @current_user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: ["Bad request"]}, status: 400
    end
  end

end
