module MessagesHelper

  def get_read_status(m)
    if m.is_unread?(@current_member_id)
      return 'message-unread'
    else
      return 'message-read'
    end
  end
end
