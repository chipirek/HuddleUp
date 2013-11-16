module ActionItemsHelper

  def get_action_item_color(a)
    if a.is_complete
      return 'item-green'
    else
      return 'item-blue'
    end
  end

end
