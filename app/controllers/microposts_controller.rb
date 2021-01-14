class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    handle_save_post
  end

  def destroy
    @micropost.destroy
    flash[:success] = t "message.delete_success"
    redirect_to request.referer || static_pages_home_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:waring] = t "micropost.mess.no_post"
    redirect_to static_pages_home_path
  end

  def handle_save_post
    if @micropost.save
      flash[:success] = t "message.micropost_success"
      redirect_to static_pages_home_path
    else
      @feed_items = current_user.feed.paginate page: params[:page],
        per_page: Settings.paginate
      render "static_pages/home"
    end
  end
end
