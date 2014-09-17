module IssuesHelper

  def get_issue_last_updated_by(iid)
    last_updated = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Issue', iid, 'Issue', iid).order('created_at desc').first
    who = User.find(last_updated.user_id).name
    return who + ', ' + time_ago_in_words(last_updated.created_at) + ' ago'
  end

end
