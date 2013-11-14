module IssuesHelper

  def get_issue_status_color2(i)
    if i.is_resolved?
      return 'item-green'
    else
      return 'item-red'
    end
  end

  def get_issue_status_color3(i)
    if i.is_resolved?
      return 'complete'
    else
      return 'incomplete'
    end
  end

end
