class HomeController < ApplicationController
  
  #  GET /home
  def index
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 3)
  end
end
