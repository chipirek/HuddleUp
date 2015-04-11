module ProjectsHelper

  def get_project_stats(p)

    total_items = p.todos.count + p.issues.count
    incomplete_items = p.todos.where('is_complete != true or is_complete is null').count + p.issues.where('is_resolved != true or is_resolved is null').count
    complete_items = total_items - incomplete_items

    if p.status_code == 0
      return 'Not started'
    end

    if total_items == 0
      percent_complete = 100
    else
      percent_complete = ((complete_items.to_f / total_items.to_f)*100).to_i
    end

    if p.status_code == 0
      percent_complete == 0
    end

    status_word = 'Not started'
    if p.status_code == 1
      status_word = 'Status: ON TRACK'
    end
    if p.status_code == 2
      status_word = 'Status: IN TROUBLE'
    end
    if p.status_code == 3
      status_word = 'Status: LATE'
    end
    if p.status_code == 4
      status_word = 'Status: PAUSED'
    end
    if p.status_code == 5
      status_word = 'Status: DONE'
    end

    if percent_complete == 0
      return '0% progress, ' + status_word
    end

    return percent_complete.to_s + '% done  (' + incomplete_items.to_s + '/' + total_items.to_s + ' items left) ' + status_word

  end


  def get_project_progress_bar(p)

    total_items = p.todos.count + p.issues.count
    incomplete_items = p.todos.where('is_complete != true or is_complete is null').count + p.issues.where('is_resolved != true or is_resolved is null').count
    complete_items = total_items - incomplete_items

    if p.status_code == 0
      s="<div class='progress-bar' aria-valuetransitiongoal='100' style='width: 100%;' aria-valuenow='100'></div>"
      return s
    end

    if total_items == 0
      percent_complete = 100
    else
      percent_complete = ((complete_items.to_f / total_items.to_f)*100).to_i
    end

    if p.status_code == 0
      percent_complete == 0
    end

    status_color = ''
    if p.status_code == 1
      status_color = 'bg-color-green'
    end
    if p.status_code == 2
      status_color = 'bg-color-orange'
    end
    if p.status_code == 3
      status_color = 'bg-color-red'
    end
    if p.status_code == 4
      status_color = 'bg-color-blueDark'
    end
    if p.status_code == 5
      status_color = 'bg-color-blueDark'
    end

    if percent_complete == 0
      s="<div class='progress-bar " + status_color + "' aria-valuetransitiongoal='100' style='width: 100%;' aria-valuenow='100'></div>"
      return s
    end

    s="<div class='progress-bar " + status_color + "' aria-valuetransitiongoal='" + percent_complete.to_s + "' style='width: " + percent_complete.to_s + "%;' aria-valuenow='" + percent_complete.to_s + "'></div>"
    return s
  end


end
