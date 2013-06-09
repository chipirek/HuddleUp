class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date

  protect_from_forgery

  protected

  def make_sure_there_is_a_working_date
    session[:working_date] = Date.today.strftime("%m/%d/%Y") unless !session[:working_date].nil?
  end

end
