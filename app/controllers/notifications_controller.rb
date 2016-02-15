class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def update
    if(current_user.unread_notifications.any?) 
      current_user.notifications.update_all(is_read: true)#.each {|notification| notification.update_attribute(:is_read, true) }
    end
    render :nothing => true, :status => 200
  end
end
