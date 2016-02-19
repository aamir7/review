class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  
  #  GET /
  def index
    if user_signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
