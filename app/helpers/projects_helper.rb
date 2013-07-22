module ProjectsHelper

  def get_project_status_text(p)
    if p.status_code == 1
      return 'On track'
    end

    if p.status_code == 2
      return 'Troubled'
    end

    return 'Late'
  end

  def get_project_status_color(p)
    if p.status_code == 1
      return 'label-success'
    end

    if p.status_code == 2
      return 'label-warning'
    end

    return 'label-important'
  end

  def get_project_progress_color(p)
    if p.status_code == 1
      return 'rgb(130, 175, 111)'
    end

    if p.status_code == 2
      return 'rgb(248, 148, 6)'
    end

    return 'rgb(209, 91, 71)'
  end

end
