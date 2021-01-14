class SessionController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      handle_activated user
    else
      flash.now[:danger] = t "account.invalid_email_password_combination"
      render new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to static_pages_home_path
  end

  private

  def handler_remember user
    if params[:session][:remember_me] == Settings.remember_status
      remember(user)
    else
      forget(user)
    end
  end

  def handle_activated user
    if user.activated?
      log_in user
      handler_remember user
      redirect_back_or user
    else
      message = t "message.not_activate"
      flash[:warning] = message
      redirect_to static_pages_home_path
    end
  end
end
