module ProjectsHelper

  def get_last_updated_by(pid)

    #--- HACK / TODO - if Audits.all.count() == 0 assume this is in smoke testing and exit
    c = Audit.all.count()
    # puts '************************** AUDITS.all.count()=' + c.to_s
    if c == 0
      puts '************************** SMOKE TESTING - HACK IN PLACE'
      return 'SMOKE TESTING - HACK IN PLACE'
    end

    last_updated = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Project', pid, 'Project', pid).order('created_at desc').first

    # puts '************************** LAST_UPDATED=' + last_updated.to_s

    who = User.find(last_updated.user_id).name
    return who + ', ' + time_ago_in_words(last_updated.created_at) + ' ago'

  end

end
