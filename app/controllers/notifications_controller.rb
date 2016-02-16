class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  #  PUT/PATCH "/notifications/update"
  def update
    unread_notifications = current_user.notifications.unread_notifications
    if(unread_notifications.any?) 
      unread_notifications.update_all(is_read: true)
    end
    data = { :notification_count => current_user.notifications.unread_notifications.count }
    render :json => data, :status => :ok
  end
end
