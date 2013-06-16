module TasksHelper

  def get_item_color(task)
    if task.is_complete
      return 'item-green'
    end

    if task.due_date.nil?
      return 'item-blue'
    end

    if task.due_date < Time.now.to_date
      return 'item-red'
    end

    return 'item-blue'
  end

end
