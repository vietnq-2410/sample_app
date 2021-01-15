class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, only: %i(edit update)
  before_action :load_user_by_email, only: %i(create)

  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "mail.send_pass"
    redirect_to static_pages_home_path
  end

  def update
    if @user.update user_params
      log_in @user
      flash[:success] = t "message.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "message.update_failed"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "message.user_warning"
    redirect_to static_pages_home_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to static_pages_home_path
  end

  def load_user_by_email
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    flash[:danger] = t "message.user_warning"
    redirect_to static_pages_home_path
  end
end
