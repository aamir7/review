module ApplicationHelper
  
  def page_title(sub_title = '')
    base_title = "Flitter"

    if sub_title.empty?
      base_title
    else
      base_title + " - " + sub_title
    end
  end

end
