module ApplicationHelper
  
  def page_title(sub_title = '')
    base_title = t(:app_title)

    if sub_title.blank?
      base_title
    else
      base_title + " - " + sub_title
    end
  end

end
