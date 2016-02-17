class NotificationsController < ApplicationController
  
  #  PATCH /notifications/read_all_notification
  def read_all
    puts "--- \n\n\n\n\n\n --"
    unread_notifications = current_user.notifications.unread
    if unread_notifications.any?
      unread_notifications.update_all(is_read: true)
    end
    
    @notification_count  = current_user.notifications.unread.count
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end
