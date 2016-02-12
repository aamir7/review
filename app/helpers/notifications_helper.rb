module NotificationsHelper
  include SessionsHelper
  
  def user_notifications
    list1 = current_user.notifications.first(30)
    list2 = unread_notifications
    (list1 + list2).uniq
  end
  
  def unread_notifications
    current_user.notifications.where("is_read = :is_read", is_read: false)
    #    user_notifications.select { |notification| !notification.is_read? }
  end
  
  def sender_user_name(notification)
    user = User.find(notification.sender_id)
    user.name
  end
end
