class PasswordResetsController < ApplicationController

  layout 'password_resets'

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    if !@user
      render json: {errors: ["Password reset not found. Please request a new password reset!"]}, status: 404
    end
    render :edit
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    if user_params[:password] != user_params[:password_confirmation]
      flash.now[:error] = "Your password confirmation doesn't match"
      render :edit
    elsif @user.password_reset_sent_at < 2.hours.ago
      flash.now[:error] = "Your password reset expired. Please require a new password reset from the app."
      render :edit
    elsif @user.update(user_params)
      @user.update(password_reset_token: nil, password_reset_sent_at: nil)
      render :success
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
