module MessagesHelper

  def get_read_status(m)
    member_id = Member.where('project_id=?', @project.id).where('user_id=?', current_user.id).first.id
    if m.is_unread_by?(member_id)
      return 'unread'
    else
      return ''
    end
  end
end
