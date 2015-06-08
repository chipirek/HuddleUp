module ProjectsHelper

  def get_project_status_color(p)

    status_color = ''

    if p.status_code == 1
      status_color = 'success'
    end
    if p.status_code == 2
      status_color = 'warning'
    end
    if p.status_code == 3
      status_color = 'danger'
    end
    if p.status_code == 4
      status_color = 'default'
    end
    if p.status_code == 5
      status_color = 'info'
    end

    return status_color
  end


  def get_project_status_text(p)

    status = ''

    if p.status_code == 0
      status = 'Not Started'
    end
    if p.status_code == 1
      status = 'On Track'
    end
    if p.status_code == 2
      status = 'Warning'
    end
    if p.status_code == 3
      status = 'In Trouble'
    end
    if p.status_code == 4
      status = 'Paused'
    end
    if p.status_code == 5
      status = 'Complete'
    end

    return status
  end


end
