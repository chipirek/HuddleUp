class UsersController < ApplicationController

  # HACK: added this small workaround to that SmartAdmin's logout command will still work
  # it routes to an href with a GET, so I need to trap it here
  def show
    sign_out current_user
    redirect_to home_index_path
  end

end

