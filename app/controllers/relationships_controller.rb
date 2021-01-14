class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy
  before_action :load_follower, only: :create

  def create
    current_user.follow(@user)
    hanler_format
  end

  def destroy
    current_user.unfollow(@user)
    hanler_format
  end

  private

  def load_relationship
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    handle_nill
  end

  def load_follower
    @user = User.find_by(id: params[:followed_id])
    return if @user

    handle_nill
  end

  def hanler_format
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def handle_nill
    flash[:warning] = t("message.user_warning")
    redirect_to static_pages_home_path
  end
end
