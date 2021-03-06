class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date

  protect_from_forgery

  around_filter :catch_not_found

  #--- HACK: workaround for CanCan needed after upgrading to Rails 4
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  #--- /HACK

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  rescue_from CanCan::AccessDenied do |exception|
    #puts '>>> SECURITY VIOLATION: ' + exception.message
    flash[:error] = exception.message + ' Consider upgrading to get more features, or contact the project admin.'
    redirect_to '/errors/error_422'
    # redirect_to root_path
  end


  private


  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Well, something went wrong. Looks like you tried to access a record that does not exist.'
    redirect_to '/errors/error_404'
  end

  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end


  protected


  def make_sure_there_is_a_working_date
    session[:working_date] = Date.today.strftime("%m/%d/%Y") unless !session[:working_date].nil?
  end


end
