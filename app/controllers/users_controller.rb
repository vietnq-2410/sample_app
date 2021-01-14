class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.paginate(page: params[:page],
      per_page: Settings.paginate.users)
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("message.user_warning")
    redirect_to static_pages_home_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "message.check_mail"
      redirect_to static_pages_home_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "message.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "message.delete_success"
    else
      flash[:failed] = t "message.delete_failed"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "message.alert_login"
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "message.user_warning"
    redirect_to(static_pages_home_path) unless current_user? @user
  end
end
