class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @micropost  = current_user.microposts.build
      @microposts = current_user.feed.paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.js { render 'microposts/next_page' }
      end
    else
      @feed_items  = Micropost.order(created_at: :asc).paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.js { render 'microposts/next_page' }
      end
    end
  end
end
