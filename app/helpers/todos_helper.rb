module TodosHelper

  def get_icon(todo)
    if todo.is_complete
      return 'icon-check'
    else
      return 'icon-check-empty'
    end
  end

  def get_item_color(todo)
    if todo.is_complete
      return 'item-green'
    end

    if todo.due_date.nil?
      return 'item-blue'
    end

    if todo.due_date < Time.now.to_date
      return 'item-red'
    end

    return 'item-blue'
  end

end
