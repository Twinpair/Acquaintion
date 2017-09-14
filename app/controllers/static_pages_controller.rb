class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed
    else
      @feed_items  = Micropost.order(created_at: :asc)
    end
  end

  def about
  end
end
