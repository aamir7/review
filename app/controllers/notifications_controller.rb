class NotificationsController < ApplicationController

  def update
    if(unread_notifications.any?) 
        current_user.notifications.each {|notification| notification.update_attribute(:is_read, true) }
    end
    render :nothing => true, :status => 200
  end
end
