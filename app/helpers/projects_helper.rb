module ProjectsHelper

  def get_project_card_progress_report(p)

    total_items = p.todos.count + p.issues.count
    incomplete_items = p.todos.where('is_complete != true or is_complete is null').count + p.issues.where('is_resolved != true or is_resolved is null').count
    complete_items = total_items - incomplete_items

    if p.status_code == 0
      s="<div class='progress-bar' aria-valuetransitiongoal='100' style='width: 100%;' aria-valuenow='100'>Not started (" + incomplete_items.to_s + "/" + total_items.to_s + " items left)</div>"
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
    status_word = 'Not started'
    if p.status_code == 1
      status_color = 'bg-color-green'
      status_word = 'ON TRACK'
    end
    if p.status_code == 2
      status_color = 'bg-color-orange'
      status_word = 'IN TROUBLE'
    end
    if p.status_code == 3
      status_color = 'bg-color-red'
      status_word = 'LATE'
    end
    if p.status_code == 4
      status_color = 'bg-color-blueDark'
      status_word = 'PAUSED'
    end
    if p.status_code == 5
      status_color = 'bg-color-blueDark'
      status_word = 'DONE'
    end

    if percent_complete == 0
      s="<div class='progress-bar " + status_color + "' aria-valuetransitiongoal='100' style='width: 100%;' aria-valuenow='100'>0% (" + incomplete_items.to_s + "/" + total_items.to_s + " items left) " + status_word + "</div>"
      return s
    end

    s="<div class='progress-bar " + status_color + "' aria-valuetransitiongoal='" + percent_complete.to_s + "' style='width: " + percent_complete.to_s + "%;' aria-valuenow='" + percent_complete.to_s + "'>" + percent_complete.to_s + "% (" + incomplete_items.to_s + "/" + total_items.to_s + " items left) " + status_word + "</div>"
    return s
  end
end
